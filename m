From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 17 Dec 2012 12:19:25 -0800
Message-ID: <20121217201925.8683B820055@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46170 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2LQUT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 15:19:26 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so687300ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 12:19:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sta2x11-mfd.c  |   19 -------------------
 net/dns_resolver/dns_key.c |    7 -------
 2 files changed, 26 deletions(-)

diff -puN drivers/mfd/sta2x11-mfd.c~linux-next-git-rejects drivers/mfd/sta2x11-mfd.c
--- a/drivers/mfd/sta2x11-mfd.c~linux-next-git-rejects
+++ a/drivers/mfd/sta2x11-mfd.c
@@ -510,20 +510,6 @@ enum mfd1_bar1_cells {
 	STA2X11_APB_SOC_REGS = 0,
 };
 
-<<<<<<< HEAD
-static const __devinitconst struct resource vic_resources[] = {
-	CELL_4K(STA2X11_MFD_VIC_NAME, STA2X11_VIC),
-};
-
-static const __devinitconst struct resource apb_soc_regs_resources[] = {
-	CELL_4K(STA2X11_MFD_APB_SOC_REGS_NAME, STA2X11_APB_SOC_REGS),
-};
-
-static __devinitdata struct mfd_cell sta2x11_mfd1_bar0[] = {
-	DEV(STA2X11_MFD_VIC_NAME, vic_resources),
-};
-
-static __devinitdata struct mfd_cell sta2x11_mfd1_bar1[] = {
 =======
 static const struct resource vic_resources[] = {
 	CELL_4K(STA2X11_MFD_VIC_NAME, STA2X11_VIC),
@@ -538,7 +524,6 @@ static struct mfd_cell sta2x11_mfd1_bar0
 };
 
 static struct mfd_cell sta2x11_mfd1_bar1[] = {
->>>>>>> linux-next/akpm-base
 	DEV(STA2X11_MFD_APB_SOC_REGS_NAME, apb_soc_regs_resources),
 };
 
@@ -607,11 +592,7 @@ static struct sta2x11_mfd_setup_data mfd
 };
 
 static void sta2x11_mfd_setup(struct pci_dev *pdev,
-<<<<<<< HEAD
 			      struct sta2x11_mfd_setup_data *sd)
-=======
-					struct sta2x11_mfd_setup_data *sd)
->>>>>>> linux-next/akpm-base
 {
 	int i, j;
 	for (i = 0; i < ARRAY_SIZE(sd->bars); i++)
diff -puN net/dns_resolver/dns_key.c~linux-next-git-rejects net/dns_resolver/dns_key.c
--- a/net/dns_resolver/dns_key.c~linux-next-git-rejects
+++ a/net/dns_resolver/dns_key.c
@@ -260,17 +260,10 @@ static int __init init_dns_resolver(void
 		return -ENOMEM;
 
 	keyring = keyring_alloc(".dns_resolver",
-<<<<<<< HEAD
-				GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
-				(KEY_POS_ALL & ~KEY_POS_SETATTR) |
-				KEY_USR_VIEW | KEY_USR_READ,
-				KEY_ALLOC_NOT_IN_QUOTA, NULL);
-=======
 			    GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, cred,
 			    (KEY_POS_ALL & ~KEY_POS_SETATTR) |
 			    KEY_USR_VIEW | KEY_USR_READ,
 			    KEY_ALLOC_NOT_IN_QUOTA, NULL);
->>>>>>> linux-next/akpm-base
 	if (IS_ERR(keyring)) {
 		ret = PTR_ERR(keyring);
 		goto failed_put_cred;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

