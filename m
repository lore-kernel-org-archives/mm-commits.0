From: akpm@linux-foundation.org
Subject: +
 smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
 added to -mm tree
Date: Thu, 16 Jul 2015 15:22:36 -0700
Message-ID: <55a82eac.HAWvL/LVSvEWcJsn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbGPWWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jul 2015 18:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: fix for allow passing the cpumask on per-cpu thread registration
has been added to the -mm tree.  Its filename is
     smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: smpboot: fix for allow passing the cpumask on per-cpu thread registration

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/smpboot.c~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix kernel/smpboot.c
--- a/kernel/smpboot.c~smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix
+++ a/kernel/smpboot.c
@@ -308,7 +308,7 @@ out:
 	put_online_cpus();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
+EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread_cpumask);
 
 /**
  * smpboot_unregister_percpu_thread - Unregister a per_cpu thread related to hotplug
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
userfaultfd-uapi-add-missing-include-typesh.patch
userfaultfd-activate-syscall-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix.patch
mm-mlock-add-new-mlock-munlock-and-munlockall-system-calls-fix-2.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

