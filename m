From: akpm@linux-foundation.org
Subject: [folded-merged]
 smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
 removed from -mm tree
Date: Fri, 04 Sep 2015 15:25:35 -0700
Message-ID: <55ea1a5f.YrWW+2RPYQO9Sk5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639AbbIDWZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2015 18:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: fix for allow passing the cpumask on per-cpu thread registration
has been removed from the -mm tree.  Its filename was
     smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch

This patch was dropped because it was folded into smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch

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

smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch

