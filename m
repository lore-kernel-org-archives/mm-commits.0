From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 18 Aug 2017 15:15:40 -0700
Message-ID: <20170818151540.af9c8d7cc87df88469b0493a@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752138AbdHRWPl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2017 18:15:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

14 fixes, based on 039a8e38473323ed9f6c4415b4c3a36777efac34:

Subject: mm: memcontrol: fix NULL pointer crash in test_clear_page_writeback()
Subject: kernel/watchdog: fix Kconfig constraints for perf hardlockup watchdog
Subject: wait: add wait_event_killable_timeout()
Subject: kmod: fix wait on recursive loop
Subject: test_kmod: fix description for -s -and -c parameters
Subject: mm: discard memblock data later
Subject: slub: fix per memcg cache leak on css offline
Subject: mm: fix double mmap_sem unlock on MMF_UNSTABLE enforced SIGBUS
Subject: mm, oom: fix potential data corruption when oom_reaper races with writer
Subject: signal: don't remove SIGNAL_UNKILLABLE for traced tasks.
Subject: mm/cma_debug.c: fix stack corruption due to sprintf usage
Subject: mm/mempolicy: fix use after free when calling get_mempolicy
Subject: mm/vmalloc.c: don't unconditonally use __GFP_HIGHMEM
Subject: mm: revert x86_64 and arm64 ELF_ET_DYN_BASE base changes

