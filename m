From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:43 -0800
Message-ID: <58b5e2df.U57uu3AypKOKoab5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdB1Uvo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "applys" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "applys" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  applys||applies

The "applyes" in drivers/video/fbdev/aty/radeon_monitor.c is a
different pattern but it was fixed in this commit.
The "This functions" in the same line was fixed as well.

Link: http://lkml.kernel.org/r/1481573103-11329-24-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/tuner-core.c           |    4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c |    2 +-
 drivers/video/fbdev/aty/radeon_monitor.c       |    2 +-
 scripts/spelling.txt                           |    1 +
 4 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/media/v4l2-core/tuner-core.c~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances drivers/media/v4l2-core/tuner-core.c
--- a/drivers/media/v4l2-core/tuner-core.c~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances
+++ a/drivers/media/v4l2-core/tuner-core.c
@@ -245,7 +245,7 @@ static const struct analog_demod_ops tun
  * @tuner_callback:	an optional function to be called when switching
  *			to analog mode
  *
- * This function applys the tuner config to tuner specified
+ * This function applies the tuner config to tuner specified
  * by tun_setup structure. It contains several per-tuner initialization "magic"
  */
 static void set_type(struct i2c_client *c, unsigned int type,
@@ -463,7 +463,7 @@ attach_failed:
  * @sd:		subdev descriptor
  * @tun_setup:	type to be associated to a given tuner i2c address
  *
- * This function applys the tuner config to tuner specified
+ * This function applies the tuner config to tuner specified
  * by tun_setup structure.
  * If tuner I2C address is UNSET, then it will only set the device
  * if the tuner supports the mode specified in the call.
diff -puN drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -1449,7 +1449,7 @@ do { \
  *  @atr_input: input bitstream to compute the hash on
  *  @input_mask: mask for the input bitstream
  *
- *  This function serves two main purposes.  First it applys the input_mask
+ *  This function serves two main purposes.  First it applies the input_mask
  *  to the atr_input resulting in a cleaned up atr_input data stream.
  *  Secondly it computes the hash and stores it in the bkt_hash field at
  *  the end of the input byte stream.  This way it will be available for
diff -puN drivers/video/fbdev/aty/radeon_monitor.c~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances drivers/video/fbdev/aty/radeon_monitor.c
--- a/drivers/video/fbdev/aty/radeon_monitor.c~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances
+++ a/drivers/video/fbdev/aty/radeon_monitor.c
@@ -646,7 +646,7 @@ void radeon_probe_screens(struct radeonf
 
 
 /*
- * This functions applyes any arch/model/machine specific fixups
+ * This function applies any arch/model/machine specific fixups
  * to the panel info. It may eventually alter EDID block as
  * well or whatever is specific to a given model and not probed
  * properly by the default code
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -105,6 +105,7 @@ appearence||appearance
 applicaion||application
 appliction||application
 applictions||applications
+applys||applies
 appplications||applications
 appropiate||appropriate
 appropriatly||appropriately
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

