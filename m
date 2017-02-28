From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:45 -0800
Message-ID: <58b5e2e1.dmqAg/dtUmCSgwt9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbdB1Uvq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "explictely" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "explictely" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  explictely||explicitly

Link: http://lkml.kernel.org/r/1481573103-11329-25-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/device-mapper/dm-raid.txt |    2 +-
 drivers/char/pcmcia/cm4000_cs.c         |    2 +-
 scripts/spelling.txt                    |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/device-mapper/dm-raid.txt~scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances Documentation/device-mapper/dm-raid.txt
--- a/Documentation/device-mapper/dm-raid.txt~scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances
+++ a/Documentation/device-mapper/dm-raid.txt
@@ -319,7 +319,7 @@ Version History
 1.5.2   'mismatch_cnt' is zero unless [last_]sync_action is "check".
 1.6.0   Add discard support (and devices_handle_discard_safely module param).
 1.7.0   Add support for MD RAID0 mappings.
-1.8.0   Explictely check for compatible flags in the superblock metadata
+1.8.0   Explicitly check for compatible flags in the superblock metadata
 	and reject to start the raid set if any are set by a newer
 	target version, thus avoiding data corruption on a raid set
 	with a reshape in progress.
diff -puN drivers/char/pcmcia/cm4000_cs.c~scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -655,7 +655,7 @@ static void terminate_monitor(struct cm4
  * monitor the card every 50msec. as a side-effect, retrieve the
  * atr once a card is inserted. another side-effect of retrieving the
  * atr is that the card will be powered on, so there is no need to
- * power on the card explictely from the application: the driver
+ * power on the card explicitly from the application: the driver
  * is already doing that for you.
  */
 
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -428,6 +428,7 @@ expecially||especially
 explicite||explicit
 explicitely||explicitly
 explict||explicit
+explictely||explicitly
 explictly||explicitly
 expresion||expression
 exprimental||experimental
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

