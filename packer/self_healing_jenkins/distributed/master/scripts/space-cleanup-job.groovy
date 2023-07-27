import jenkins.model.Jenkins
    import hudson.model.Job

    BUILDS_TO_KEEP = 5

    for (job in Jenkins.instance.items) {
      println job.name

      def recent = job.builds.limit(BUILDS_TO_KEEP)

      for (build in job.builds) {
        if (!recent.contains(build)) {
          println "Preparing to delete: " + build
          build.delete()
        }
      }
    }
