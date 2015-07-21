From: akpm@linux-foundation.org
Subject: [merged] sound-soc-codecs-cs4349c-include-gpio-consumerh.patch
 removed from -mm tree
Date: Tue, 21 Jul 2015 12:05:05 -0700
Message-ID: <55ae97e1.m9Pzt3skL1AL6fiE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378AbbGUTFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jul 2015 15:05:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Paul.Handrigan@cirrus.com, brian.austin@cirrus.com, broonie@kernel.org, lgirdwood@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sound/soc/codecs/cs4349.c: include gpio/consumer.h
has been removed from the -mm tree.  Its filename was
     sound-soc-codecs-cs4349c-include-gpio-consumerh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sound/soc/codecs/cs4349.c: include gpio/consumer.h

s390 allmodconfig:

sound/soc/codecs/cs4349.c: In function 'cs4349_i2c_probe':
sound/soc/codecs/cs4349.c:300: error: implicit declaration of function 'devm_gpiod_get_optional'
sound/soc/codecs/cs4349.c:301: error: 'GPIOD_OUT_LOW' undeclared (first use in this function)
sound/soc/codecs/cs4349.c:301: error: (Each undeclared identifier is reported only once
sound/soc/codecs/cs4349.c:301: error: for each function it appears in.)
sound/soc/codecs/cs4349.c:306: error: implicit declaration of function 'gpiod_set_value_cansleep'

Cc: Brian Austin <brian.austin@cirrus.com>
Cc: Paul Handrigan <Paul.Handrigan@cirrus.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/soc/codecs/cs4349.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN sound/soc/codecs/cs4349.c~sound-soc-codecs-cs4349c-include-gpio-consumerh sound/soc/codecs/cs4349.c
--- a/sound/soc/codecs/cs4349.c~sound-soc-codecs-cs4349c-include-gpio-consumerh
+++ a/sound/soc/codecs/cs4349.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

