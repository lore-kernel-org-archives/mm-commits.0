From: akpm@linux-foundation.org
Subject: - git-cryptodev-build-failure-pasemi-rng-driver.patch removed from -mm tree
Date: Sat, 01 Dec 2007 03:57:04 -0800
Message-ID: <200712011157.lB1Bv4F3021514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269AbXLAL5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 1 Dec 2007 06:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamalesh@linux.vnet.ibm.com, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     git-cryptodev: build failure pasemi-rng driver
has been removed from the -mm tree.  Its filename was
     git-cryptodev-build-failure-pasemi-rng-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-cryptodev: build failure pasemi-rng driver
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

drivers/char/hw_random/pasemi-rng.c: In function `pasemi_rng_data_present':
drivers/char/hw_random/pasemi-rng.c:53: error: `wait' undeclared (first use in this function)
drivers/char/hw_random/pasemi-rng.c:53: error: (Each undeclared identifier is reported only once
drivers/char/hw_random/pasemi-rng.c:53: error: for each function it appears in.)
drivers/char/hw_random/pasemi-rng.c: At top level:
drivers/char/hw_random/pasemi-rng.c:93: warning: initialization from incompatible pointer type

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/pasemi-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/hw_random/pasemi-rng.c~git-cryptodev-build-failure-pasemi-rng-driver drivers/char/hw_random/pasemi-rng.c
--- a/drivers/char/hw_random/pasemi-rng.c~git-cryptodev-build-failure-pasemi-rng-driver
+++ a/drivers/char/hw_random/pasemi-rng.c
@@ -42,7 +42,7 @@
 
 #define MODULE_NAME "pasemi_rng"
 
-static int pasemi_rng_data_present(struct hwrng *rng)
+static int pasemi_rng_data_present(struct hwrng *rng, int wait)
 {
 	void __iomem *rng_regs = (void __iomem *)rng->priv;
 	int data, i;
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
powerpc-stop-the-toc-overflowing-for-large-builds.patch
git-cryptodev.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial-slub-workaround-for-lockdep-confusion.patch
config_highpte-vs-sub-page-page-tables-fix.patch
inotify-send-in_attrib-events-when-link-count-changes-fix.patch
iget-stop-bfs-from-using-iget-and-read_inode-try-fix.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
