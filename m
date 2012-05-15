From: akpm@linux-foundation.org
Subject: + kernel-cpu_pmc-fix-various-typos.patch added to -mm tree
Date: Tue, 15 May 2012 14:57:03 -0700
Message-ID: <20120515215703.99F8FA028F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:56477 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab2EOV5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 May 2012 17:57:05 -0400
Received: by eaao13 with SMTP id o13so2543eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 15 May 2012 14:57:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nico@fluxnic.net, ccross@android.com, nico@linaro.org, santosh.shilimkar@ti.com


The patch titled
     Subject: kernel/cpu_pm.c: fix various typos
has been added to the -mm tree.  Its filename is
     kernel-cpu_pmc-fix-various-typos.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicolas Pitre <nico@fluxnic.net>
Subject: kernel/cpu_pm.c: fix various typos

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Colin Cross <ccross@android.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu_pm.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN kernel/cpu_pm.c~kernel-cpu_pmc-fix-various-typos kernel/cpu_pm.c
--- a/kernel/cpu_pm.c~kernel-cpu_pmc-fix-various-typos
+++ a/kernel/cpu_pm.c
@@ -81,7 +81,7 @@ int cpu_pm_unregister_notifier(struct no
 EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
 
 /**
- * cpm_pm_enter - CPU low power entry notifier
+ * cpu_pm_enter - CPU low power entry notifier
  *
  * Notifies listeners that a single CPU is entering a low power state that may
  * cause some blocks in the same power domain as the cpu to reset.
@@ -89,7 +89,7 @@ EXPORT_SYMBOL_GPL(cpu_pm_unregister_noti
  * Must be called on the affected CPU with interrupts disabled.  Platform is
  * responsible for ensuring that cpu_pm_enter is not called twice on the same
  * CPU before cpu_pm_exit is called. Notified drivers can include VFP
- * co-processor, interrupt controller and it's PM extensions, local CPU
+ * co-processor, interrupt controller and its PM extensions, local CPU
  * timers context save/restore which shouldn't be interrupted. Hence it
  * must be called with interrupts disabled.
  *
@@ -115,13 +115,13 @@ int cpu_pm_enter(void)
 EXPORT_SYMBOL_GPL(cpu_pm_enter);
 
 /**
- * cpm_pm_exit - CPU low power exit notifier
+ * cpu_pm_exit - CPU low power exit notifier
  *
  * Notifies listeners that a single CPU is exiting a low power state that may
  * have caused some blocks in the same power domain as the cpu to reset.
  *
  * Notified drivers can include VFP co-processor, interrupt controller
- * and it's PM extensions, local CPU timers context save/restore which
+ * and its PM extensions, local CPU timers context save/restore which
  * shouldn't be interrupted. Hence it must be called with interrupts disabled.
  *
  * Return conditions are same as __raw_notifier_call_chain.
@@ -139,7 +139,7 @@ int cpu_pm_exit(void)
 EXPORT_SYMBOL_GPL(cpu_pm_exit);
 
 /**
- * cpm_cluster_pm_enter - CPU cluster low power entry notifier
+ * cpu_cluster_pm_enter - CPU cluster low power entry notifier
  *
  * Notifies listeners that all cpus in a power domain are entering a low power
  * state that may cause some blocks in the same power domain to reset.
@@ -147,7 +147,7 @@ EXPORT_SYMBOL_GPL(cpu_pm_exit);
  * Must be called after cpu_pm_enter has been called on all cpus in the power
  * domain, and before cpu_pm_exit has been called on any cpu in the power
  * domain. Notified drivers can include VFP co-processor, interrupt controller
- * and it's PM extensions, local CPU timers context save/restore which
+ * and its PM extensions, local CPU timers context save/restore which
  * shouldn't be interrupted. Hence it must be called with interrupts disabled.
  *
  * Must be called with interrupts disabled.
@@ -174,7 +174,7 @@ int cpu_cluster_pm_enter(void)
 EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
 
 /**
- * cpm_cluster_pm_exit - CPU cluster low power exit notifier
+ * cpu_cluster_pm_exit - CPU cluster low power exit notifier
  *
  * Notifies listeners that all cpus in a power domain are exiting form a
  * low power state that may have caused some blocks in the same power domain
@@ -183,7 +183,7 @@ EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
  * Must be called after cpu_pm_exit has been called on all cpus in the power
  * domain, and before cpu_pm_exit has been called on any cpu in the power
  * domain. Notified drivers can include VFP co-processor, interrupt controller
- * and it's PM extensions, local CPU timers context save/restore which
+ * and its PM extensions, local CPU timers context save/restore which
  * shouldn't be interrupted. Hence it must be called with interrupts disabled.
  *
  * Return conditions are same as __raw_notifier_call_chain.
_
Subject: Subject: kernel/cpu_pm.c: fix various typos

Patches currently in -mm which might be from nico@fluxnic.net are

linux-next.patch
kernel-cpu_pmc-fix-various-typos.patch

