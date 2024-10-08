# kubectl ephemeral-containers

A `kubectl` plugin for directly modifying Pods' [`ephemeralContainers` spec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.31/#ephemeralcontainer-v1-core).


An [ephemeral container](https://kubernetes.io/docs/concepts/workloads/pods/ephemeral-containers/) is a temporary container that is injected into existing Pods for some user-initiated actions, for example, troubleshooting. However, ephemeral container specs must be handled as a Pod's `ephemeralcontainers` subresource. Consequently, `kubectl edit` cannot be used for modifying `pod.spec.ephemeralcontainers`.


This project is a plugin (i.e. an extension) to `kubectl` that allows such direct editing, bringing back the experience of `kubectl edit`. For more information on how to extend `kubectl`, see [guides](https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/).


## Requirements

- Kubernetes `>= v1.25.0-0`
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

## Installation

### Build from source

```bash
git clone git@github.com:k8s-crafts/ephemeral-containers-plugin.git
cd ephemeral-containers-plugin
# Build the plugin and install it on PATH
# Default to $HOME/bin
make build install
# Checking plugin version
kubectl ephemeral-containers version
```

## Command-line Options

The flag `--help` can be used to display available command-line options.

```console
$ kubectl ephemeral-containers --help
A kubectl plugin to directly modify pods.spec.ephemeralContainers. It works by interacting the pod's ephemeralcontainers subresource

Usage:
  kubectl ephemeral-containers [command]

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  edit        Command to edit the ephemeralContainers spec for a Pod
  help        Help about any command
  list        List the Pods with ephemeral containers in the current namespace
  version     Output the plugin version

Flags:
      --add_dir_header                   If true, adds the file directory to the header of the log messages
      --alsologtostderr                  log to standard error as well as files (no effect when -logtostderr=true)
      --as string                        Username to impersonate for the operation. User could be a regular user or a service account in a namespace.
      --as-group stringArray             Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
      --as-uid string                    UID to impersonate for the operation.
      --cache-dir string                 Default cache directory (default "/home/thvo/.kube/cache")
      --certificate-authority string     Path to a cert file for the certificate authority
      --client-certificate string        Path to a client certificate file for TLS
      --client-key string                Path to a client key file for TLS
      --cluster string                   The name of the kubeconfig cluster to use
      --context string                   The name of the kubeconfig context to use
      --disable-compression              If true, opt-out of response compression for all requests to the server
  -h, --help                             
      --insecure-skip-tls-verify         If true, the server's certificate will not be checked for validity. This will make your HTTPS connections insecure
      --kubeconfig string                Path to the kubeconfig file to use for CLI requests.
      --log_backtrace_at traceLocation   when logging hits line file:N, emit a stack trace (default :0)
      --log_dir string                   If non-empty, write log files in this directory (no effect when -logtostderr=true)
      --log_file string                  If non-empty, use this log file (no effect when -logtostderr=true)
      --log_file_max_size uint           Defines the maximum size a log file can grow to (no effect when -logtostderr=true). Unit is megabytes. If the value is 0, the maximum file size is unlimited. (default 1800)
      --logtostderr                      log to standard error instead of files
  -n, --namespace string                 If present, the namespace scope for this CLI request
      --one_output                       If true, only write logs to their native severity level (vs also writing to each lower severity level; no effect when -logtostderr=true)
  -o, --output string                    Format for output. One of: table (default), json, yaml (default "table")
      --request-timeout string           The length of time to wait before giving up on a single server request. Non-zero values should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don't timeout requests. (default "0")
  -s, --server string                    The address and port of the Kubernetes API server
      --skip_headers                     If true, avoid header prefixes in the log messages
      --skip_log_headers                 If true, avoid headers when opening log files (no effect when -logtostderr=true)
      --stderrthreshold severity         logs at or above this threshold go to stderr when writing to files and stderr (no effect when -logtostderr=true or -alsologtostderr=true) (default 2)
      --tls-server-name string           Server name to use for server certificate validation. If it is not provided, the hostname used to contact the server is used
      --token string                     Bearer token for authentication to the API server
      --user string                      The name of the kubeconfig user to use
  -v, --v Level                          number for the log level verbosity
      --vmodule moduleSpec               comma-separated list of pattern=N settings for file-filtered logging

Use "kubectl ephemeral-containers [command] --help" for more information about a command.
```
