From: akpm@osdl.org
Subject: - fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:46:32 -0800
Message-ID: <200701302146.l0ULkW17030104@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51946 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbXA3Vr2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     Fix "CONFIG_X86_64_" typo in drivers/kvm/svm.c
has been removed from the -mm tree.  Its filename was
     fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix "CONFIG_X86_64_" typo in drivers/kvm/svm.c
From: "Robert P. J. Day" <rpjday@mindspring.com>

Fix what looks like an obvious typo in the file drivers/kvm/svm.c.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/svm.c~fix-config_x86_64_-typo-in-drivers-kvm-svmc drivers/kvm/svm.c
--- a/drivers/kvm/svm.c~fix-config_x86_64_-typo-in-drivers-kvm-svmc
+++ a/drivers/kvm/svm.c
@@ -1163,7 +1163,7 @@ static int svm_set_msr(struct kvm_vcpu *
 	case MSR_K6_STAR:
 		vcpu->svm->vmcb->save.star = data;
 		break;
-#ifdef CONFIG_X86_64_
+#ifdef CONFIG_X86_64
 	case MSR_LSTAR:
 		vcpu->svm->vmcb->save.lstar = data;
 		break;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-acpi.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
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
fix-apparent-typo-config_lockdep_debug.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
