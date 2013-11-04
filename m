From: akpm@linux-foundation.org
Subject: [to-be-updated]
 input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch removed
 from -mm tree
Date: Mon, 04 Nov 2013 12:20:53 -0800
Message-ID: <527801a5.T+jePSqRJEnaPYLj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3KDUUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 15:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, samuel.thibault@ens-lyon.org, ralf@linux-mips.org, dmitry.torokhov@gmail.com, blogic@openwrt.org, akpm@linux-foundation.org

Subject: [to-be-updated] input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,blogic@openwrt.org,dmitry.torokhov@gmail.com,ralf@linux-mips.org,samuel.thibault@ens-lyon.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 12:20:53 -0800


The patch titled
     Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix
has been removed from the -mm tree.  Its filename was
     input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix

use IS_ENABLED to pick up CONFIG_INPUT_LEDS=m

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix include/linux/input.h
--- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix
+++ a/include/linux/input.h
@@ -533,7 +533,7 @@ int input_ff_erase(struct input_dev *dev
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
-#ifdef CONFIG_INPUT_LEDS
+#if IS_ENABLED(CONFIG_INPUT_LEDS)
 
 int input_led_connect(struct input_dev *dev);
 void input_led_disconnect(struct input_dev *dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
kfifo-api-type-safety-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

