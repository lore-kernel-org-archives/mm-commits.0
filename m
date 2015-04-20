From: akpm@linux-foundation.org
Subject: [merged] documentation-spi-spidev_testc-fix-warning.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:21:05 -0700
Message-ID: <553551a1.n9uqTGy/+NSOYAX1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbbDTTOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/spi/spidev_test.c: fix warning
has been removed from the -mm tree.  Its filename was
     documentation-spi-spidev_testc-fix-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/spi/spidev_test.c: fix warning

Documentation/spi/spidev_test.c:83:5: warning: no previous prototype for 'unespcape' [-Wmissing-prototypes]

fix spelling too.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spidev_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/spi/spidev_test.c~documentation-spi-spidev_testc-fix-warning Documentation/spi/spidev_test.c
--- a/Documentation/spi/spidev_test.c~documentation-spi-spidev_testc-fix-warning
+++ a/Documentation/spi/spidev_test.c
@@ -80,7 +80,7 @@ static void hex_dump(const void *src, si
  *  Unescape - process hexadecimal escape character
  *      converts shell input "\x23" -> 0x23
  */
-int unespcape(char *_dst, char *_src, size_t len)
+static int unescape(char *_dst, char *_src, size_t len)
 {
 	int ret = 0;
 	char *src = _src;
@@ -304,7 +304,7 @@ int main(int argc, char *argv[])
 		size = strlen(input_tx+1);
 		tx = malloc(size);
 		rx = malloc(size);
-		size = unespcape((char *)tx, input_tx, size);
+		size = unescape((char *)tx, input_tx, size);
 		transfer(fd, tx, rx, size);
 		free(rx);
 		free(tx);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

