#!/bin/bash
# Istio Installation Script
# This script installs Istio with production-ready configuration

set -e

# Configuration variables
ISTIO_VERSION="1.20.2"
INSTALL_PROFILE="default"  # Options: default, demo, minimal, remote, empty, preview
NAMESPACE="istio-system"

echo "🚀 Installing Istio ${ISTIO_VERSION}..."

# Download Istio if not already present
if [ ! -d "istio-${ISTIO_VERSION}" ]; then
    echo "📦 Downloading Istio ${ISTIO_VERSION}..."
    curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -
fi

# Add istioctl to PATH
export PATH="$PWD/istio-${ISTIO_VERSION}/bin:$PATH"

# Verify istioctl is available
if ! command -v istioctl &> /dev/null; then
    echo "❌ istioctl not found in PATH"
    exit 1
fi

echo "✅ Found istioctl version: $(istioctl version --short --remote=false)"

# Pre-check cluster compatibility
echo "🔍 Checking cluster compatibility..."
istioctl x precheck

# Install Istio with the specified profile
echo "📥 Installing Istio control plane with '${INSTALL_PROFILE}' profile..."
istioctl install --set values.defaultRevision=default \
                  --set values.pilot.env.EXTERNAL_ISTIOD=false \
                  -y

# Verify installation
echo "✅ Verifying Istio installation..."
istioctl verify-install

# Wait for control plane to be ready
echo "⏳ Waiting for Istio control plane to be ready..."
kubectl wait --for=condition=Ready pods -l app=istiod -n ${NAMESPACE} --timeout=300s

# Enable sidecar injection for default namespace
echo "🔧 Enabling sidecar injection for default namespace..."
kubectl label namespace default istio-injection=enabled --overwrite

# Install observability addons (optional)
read -p "🔍 Do you want to install observability addons (Kiali, Jaeger, Grafana)? (y/n): " install_addons
if [[ $install_addons == "y" || $install_addons == "Y" ]]; then
    echo "📊 Installing observability addons..."
    
    # Apply addons from samples directory
    kubectl apply -f istio-${ISTIO_VERSION}/samples/addons/prometheus.yaml
    kubectl apply -f istio-${ISTIO_VERSION}/samples/addons/grafana.yaml
    kubectl apply -f istio-${ISTIO_VERSION}/samples/addons/jaeger.yaml
    kubectl apply -f istio-${ISTIO_VERSION}/samples/addons/kiali.yaml
    
    # Wait for addons to be ready
    echo "⏳ Waiting for addons to be ready..."
    kubectl wait --for=condition=Ready pods -l app=prometheus -n ${NAMESPACE} --timeout=300s
    kubectl wait --for=condition=Ready pods -l app=grafana -n ${NAMESPACE} --timeout=300s
    kubectl wait --for=condition=Ready pods -l app=jaeger -n ${NAMESPACE} --timeout=300s
    kubectl wait --for=condition=Ready pods -l app=kiali -n ${NAMESPACE} --timeout=300s
    
    echo "📊 Observability addons installed successfully!"
    echo "Access them using:"
    echo "  - Kiali:      istioctl dashboard kiali"
    echo "  - Jaeger:     istioctl dashboard jaeger"
    echo "  - Grafana:    istioctl dashboard grafana"
    echo "  - Prometheus: istioctl dashboard prometheus"
fi

# Display cluster status
echo ""
echo "🎉 Istio installation completed successfully!"
echo ""
echo "📋 Cluster status:"
kubectl get pods -n ${NAMESPACE}
echo ""
echo "🔧 Next steps:"
echo "1. Deploy applications to namespaces with sidecar injection enabled"
echo "2. Configure traffic management with VirtualServices and DestinationRules"
echo "3. Set up security policies with PeerAuthentication and AuthorizationPolicy"
echo ""
echo "📚 Useful commands:"
echo "  - Check installation: istioctl verify-install"
echo "  - Analyze config:     istioctl analyze"
echo "  - Proxy status:       istioctl proxy-status"
echo "  - Enable injection:   kubectl label namespace <namespace> istio-injection=enabled"