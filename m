From: akpm@osdl.org
Subject: - kconfig-printk_time-depends-on-printk.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:58 -0800
Message-ID: <200612072302.kB7N2wVi029917@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163811AbWLGXDK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kconfig: PRINTK_TIME depends on PRINTK
has been removed from the -mm tree.  Its filename was
     kconfig-printk_time-depends-on-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kconfig: PRINTK_TIME depends on PRINTK
From: Randy Dunlap <randy.dunlap@oracle.com>

Make PRINTK_TIME depend on PRINTK.  Only display/offer it if PRINTK is
enabled.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~kconfig-printk_time-depends-on-printk lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-printk_time-depends-on-printk
+++ a/lib/Kconfig.debug
@@ -1,6 +1,7 @@
 
 config PRINTK_TIME
 	bool "Show timing information on printks"
+	depends on PRINTK
 	help
 	  Selecting this option causes timing information to be
 	  included in printk output.  This allows you to measure
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

