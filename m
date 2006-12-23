From: akpm@osdl.org
Subject: - cpufreq-select-consistently-re-2619-rc5-mm1.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:55:21 -0800
Message-ID: <200612230755.kBN7tLWs010289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbWLWHzk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:55:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: select consistently
has been removed from the -mm tree.  Its filename was
     cpufreq-select-consistently-re-2619-rc5-mm1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq: select consistently
From: Randy Dunlap <randy.dunlap@oracle.com>

Make x86_64 ACPI_CPU_FREQ select CPU_FREQ_TABLE like other methods do. 
(although we should still eliminate as much use of 'select' as possible)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/cpufreq/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/cpufreq/Kconfig~cpufreq-select-consistently-re-2619-rc5-mm1 arch/x86_64/kernel/cpufreq/Kconfig
--- a/arch/x86_64/kernel/cpufreq/Kconfig~cpufreq-select-consistently-re-2619-rc5-mm1
+++ a/arch/x86_64/kernel/cpufreq/Kconfig
@@ -49,6 +49,7 @@ config X86_SPEEDSTEP_CENTRINO_ACPI
 
 config X86_ACPI_CPUFREQ
 	tristate "ACPI Processor P-States driver"
+	select CPU_FREQ_TABLE
 	depends on ACPI_PROCESSOR
 	help
 	  This driver adds a CPUFreq driver which utilizes the ACPI
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
git-cpufreq.patch
git-gfs2-nmw.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

