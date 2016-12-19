From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch added to -mm tree
Date: Mon, 19 Dec 2016 14:26:34 -0800
Message-ID: <58585e9a.iy0xcILWR7XaJdD8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSWZf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "neded" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch

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
Subject: scripts/spelling.txt: add "neded" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  neded||needed

While we are here, fix the "overriden", "wont", and "etc" in the
same hunk in drivers/media/usb/tm6000/tm6000-input.c.

Link: http://lkml.kernel.org/r/1481573103-11329-14-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/usb/gspca/t613.c          |    6 +++---
 drivers/media/usb/tm6000/tm6000-input.c |    2 +-
 scripts/spelling.txt                    |    1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/media/usb/gspca/t613.c~scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances drivers/media/usb/gspca/t613.c
--- a/drivers/media/usb/gspca/t613.c~scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances
+++ a/drivers/media/usb/gspca/t613.c
@@ -574,9 +574,9 @@ static void setfreq(struct gspca_dev *gs
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	/* some of this registers are not really neded, because
-	 * they are overriden by setbrigthness, setcontrast, etc,
-	 * but wont hurt anyway, and can help someone with similar webcam
+	/* some of this registers are not really needed, because
+	 * they are overridden by setbrigthness, setcontrast, etc.,
+	 * but won't hurt anyway, and can help someone with similar webcam
 	 * to see the initial parameters.*/
 	struct sd *sd = (struct sd *) gspca_dev;
 	const struct additional_sensor_data *sensor;
diff -puN drivers/media/usb/tm6000/tm6000-input.c~scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances drivers/media/usb/tm6000/tm6000-input.c
--- a/drivers/media/usb/tm6000/tm6000-input.c~scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances
+++ a/drivers/media/usb/tm6000/tm6000-input.c
@@ -442,7 +442,7 @@ int tm6000_ir_init(struct tm6000_core *d
 
 	/* input setup */
 	rc->allowed_protocols = RC_BIT_RC5 | RC_BIT_NEC;
-	/* Neded, in order to support NEC remotes with 24 or 32 bits */
+	/* Needed, in order to support NEC remotes with 24 or 32 bits */
 	rc->scancode_mask = 0xffff;
 	rc->priv = ir;
 	rc->change_protocol = tm6000_ir_change_protocol;
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -675,6 +675,7 @@ neccecary||necessary
 neccesary||necessary
 neccessary||necessary
 necesary||necessary
+neded||needed
 negaive||negative
 negoitation||negotiation
 negotation||negotiation
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

