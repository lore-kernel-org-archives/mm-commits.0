From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
 added to -mm tree
Date: Mon, 19 Dec 2016 14:26:45 -0800
Message-ID: <58585ea5.pu597n8lQzFRB0wA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSWZq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "intialise(d)" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "intialise(d)" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  intialisation||initialisation
  intialised||initialised
  intialise||initialise

This commit does not intend to change the British spelling itself.

Link: http://lkml.kernel.org/r/1481573103-11329-18-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 certs/blacklist.c                               |    2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c |    8 ++++----
 drivers/video/fbdev/intelfb/intelfbdrv.c        |    2 +-
 fs/inode.c                                      |    2 +-
 fs/xfs/xfs_log_recover.c                        |    2 +-
 scripts/spelling.txt                            |    3 +++
 6 files changed, 11 insertions(+), 8 deletions(-)

diff -puN certs/blacklist.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances certs/blacklist.c
--- a/certs/blacklist.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances
+++ a/certs/blacklist.c
@@ -140,7 +140,7 @@ int is_hash_blacklisted(const u8 *hash,
 EXPORT_SYMBOL_GPL(is_hash_blacklisted);
 
 /*
- * Intialise the blacklist
+ * Initialise the blacklist
  */
 static int __init blacklist_init(void)
 {
diff -puN drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -387,7 +387,7 @@ static void sxgbe_free_rx_buffers(struct
 /**
  * init_tx_ring - init the TX descriptor ring
  * @dev: net device structure
- * @tx_ring: ring to be intialised
+ * @tx_ring: ring to be initialised
  * @tx_rsize: ring size
  * Description:  this function initializes the DMA TX descriptor
  */
@@ -437,7 +437,7 @@ dmamem_err:
 /**
  * free_rx_ring - free the RX descriptor ring
  * @dev: net device structure
- * @rx_ring: ring to be intialised
+ * @rx_ring: ring to be initialised
  * @rx_rsize: ring size
  * Description:  this function initializes the DMA RX descriptor
  */
@@ -453,7 +453,7 @@ static void free_rx_ring(struct device *
 /**
  * init_rx_ring - init the RX descriptor ring
  * @dev: net device structure
- * @rx_ring: ring to be intialised
+ * @rx_ring: ring to be initialised
  * @rx_rsize: ring size
  * Description:  this function initializes the DMA RX descriptor
  */
@@ -539,7 +539,7 @@ err_free_dma_rx:
 /**
  * free_tx_ring - free the TX descriptor ring
  * @dev: net device structure
- * @tx_ring: ring to be intialised
+ * @tx_ring: ring to be initialised
  * @tx_rsize: ring size
  * Description:  this function initializes the DMA TX descriptor
  */
diff -puN drivers/video/fbdev/intelfb/intelfbdrv.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances drivers/video/fbdev/intelfb/intelfbdrv.c
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances
+++ a/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -934,7 +934,7 @@ static __inline__ int var_to_refresh(con
 }
 
 /***************************************************************
- *                Various intialisation functions              *
+ *                Various initialisation functions             *
  ***************************************************************/
 
 static void get_initial_mode(struct intelfb_info *dinfo)
diff -puN fs/inode.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances fs/inode.c
--- a/fs/inode.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances
+++ a/fs/inode.c
@@ -119,7 +119,7 @@ static int no_open(struct inode *inode,
 }
 
 /**
- * inode_init_always - perform inode structure intialisation
+ * inode_init_always - perform inode structure initialisation
  * @sb: superblock inode belongs to
  * @inode: inode to initialise
  *
diff -puN fs/xfs/xfs_log_recover.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances fs/xfs/xfs_log_recover.c
--- a/fs/xfs/xfs_log_recover.c~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances
+++ a/fs/xfs/xfs_log_recover.c
@@ -3796,7 +3796,7 @@ xlog_recover_bud_pass2(
  * This routine is called when an inode create format structure is found in a
  * committed transaction in the log.  It's purpose is to initialise the inodes
  * being allocated on disk. This requires us to get inode cluster buffers that
- * match the range to be intialised, stamped with inode templates and written
+ * match the range to be initialised, stamped with inode templates and written
  * by delayed write so that subsequent modifications will hit the cached buffer
  * and only need writing out at the end of recovery.
  */
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -576,6 +576,9 @@ interruptted||interrupted
 interupted||interrupted
 interupt||interrupt
 intial||initial
+intialisation||initialisation
+intialised||initialised
+intialise||initialise
 intialization||initialization
 intialized||initialized
 intialize||initialize
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

