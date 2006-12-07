From: akpm@osdl.org
Subject: - reporting-bugs-request-config-file.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:58 -0800
Message-ID: <200612072307.kB7N7wCX030412@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163964AbWLGXIO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     REPORTING-BUGS: request .config file
has been removed from the -mm tree.  Its filename was
     reporting-bugs-request-config-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: REPORTING-BUGS: request .config file
From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel .config file to REPORTING-BUGS.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 REPORTING-BUGS |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN REPORTING-BUGS~reporting-bugs-request-config-file REPORTING-BUGS
--- a/REPORTING-BUGS~reporting-bugs-request-config-file
+++ a/REPORTING-BUGS
@@ -40,7 +40,9 @@ summary from [1.]>" for easy identificat
 [1.] One line summary of the problem:
 [2.] Full description of the problem/report:
 [3.] Keywords (i.e., modules, networking, kernel):
-[4.] Kernel version (from /proc/version):
+[4.] Kernel information
+[4.1.] Kernel version (from /proc/version):
+[4.2.] Kernel .config file:
 [5.] Most recent kernel version which did not have the bug:
 [6.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
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

