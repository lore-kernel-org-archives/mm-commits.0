From: akpm@osdl.org
Subject: + fix-apparent-typo-config_serial_cpm_smc.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:23:03 -0800
Message-ID: <200701260623.l0Q6N3go009296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47914 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030787AbXAZGXI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:23:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     Fix apparent typo "CONFIG_SERIAL_CPM_SMC"
has been added to the -mm tree.  Its filename is
     fix-apparent-typo-config_serial_cpm_smc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix apparent typo "CONFIG_SERIAL_CPM_SMC"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace an apparent typo of CONFIG_SERIAL_CPM_SMC with
CONFIG_SERIAL_CPM_SMC2.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ppc/platforms/mpc866ads_setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ppc/platforms/mpc866ads_setup.c~fix-apparent-typo-config_serial_cpm_smc arch/ppc/platforms/mpc866ads_setup.c
--- a/arch/ppc/platforms/mpc866ads_setup.c~fix-apparent-typo-config_serial_cpm_smc
+++ a/arch/ppc/platforms/mpc866ads_setup.c
@@ -369,7 +369,7 @@ int __init mpc866ads_init(void)
 	ppc_sys_device_setfunc(MPC8xx_CPM_SMC1, PPC_SYS_FUNC_UART);
 #endif
 
-#ifdef CONFIG_SERIAL_CPM_SMC
+#ifdef CONFIG_SERIAL_CPM_SMC2
 	ppc_sys_device_enable(MPC8xx_CPM_SMC2);
 	ppc_sys_device_setfunc(MPC8xx_CPM_SMC2, PPC_SYS_FUNC_UART);
 #endif
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
remove-unused-kernel-config-option-x86_xadd.patch
uml-fix-apparent-config_64_bit-typo.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
