class Job
  state_machine initial: :received


  state :received do
    def status
      JobStatus::Received
    end

    # validate whether we're ready to start the job
  end
  state :working do
    def status
      JobStatus::Working
    end

    # transcoding is currently happening on an ffmpeg pod
  end
  state :finished do
    def status
      JobStatus::Finished
    end

    # received job completed transition, turn off flag to kill pod
  end

  event :start_transcoding do
    transition :received => :working
  end


  event :are_we_done do
    transition :working => :finished, if: ->(job) {job.is_done?}
  end

  def is_done?


  end

end

module JobStatus
  Received = 0
  Working = 1
  Finished = 2
end
#   message received

# reading queue...

# got SQSMESSAGE

# create POD using info from SQSMESSAGE

# POD checks whether FILENAME was started (NO)


# delete SQSMESSAGE from queue

# POD is working...

# POD finishes transcode, script exits, pod dies

# POD restarts

# POD checks whether FILENAME was started (YES), permadies