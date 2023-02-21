# Kustomize Best Practices
 - Keep your custom resources and their instances in separate packages, otherwise you will encounter race conditions and your creation will get stuck. For example, many people keep both the CertManager CRD and CertManager’s resources in the same package, which can cause problems. Most of the time, reapplying the YAML fixes the issue. But it's good practice to keep them separately.
 - Try to keep the common values like namespace, common metadata in the base file.
 - Organize your resources by kind, using the following naming convention: lowercase-hypenated.yaml (e.g., horizontal-pod-autoscaler.yaml). Place services in the service.yaml file.
 - Follow standard directory structure, using bases/ for base files and patches/ or overlays/ for environment-specific files.
 - While developing or before pushing to git, run kubectl kustomize cfg fmt file_name to format the file and set the indentation right.

#### To confirm that your patch config file changes are correct before applying to the cluster

> kustomize build overlays/dev

#### Apply Patches

> kubectl apply -k  overlays/dev 


Output:
 ´´´
kubectl apply -k  overlays/dev 
service/frontend-service created
deployment.apps/frontend-deployment created
horizontalpodautoscaler.autoscaling/frontend-deployment-hpa created
 ´´´

