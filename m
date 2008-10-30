From: akpm@linux-foundation.org
Subject: + cirrusfb-remove-unused-variables.patch added to -mm tree
Date: Thu, 30 Oct 2008 15:00:05 -0700
Message-ID: <200810302200.m9UM052S030202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbYJ3WAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 18:00:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vlada.peric@gmail.com, krzysztof.h1@wp.pl


The patch titled
     cirrusfb: remove unused variables
has been added to the -mm tree.  Its filename is
     cirrusfb-remove-unused-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: cirrusfb: remove unused variables
=46rom: "Vlada Peric" <vlada.peric@gmail.com>

After commit a1d35a7a (cirrusfb: use modedb and add mode_option
parameter), these variables are no longer used, so remove them to fix
compilation warning.

Signed-off-by: Vlada Peri=E6 <vlada.peric@gmail.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-remove-unused-variables dri=
vers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-remove-unused-variables
+++ a/drivers/video/cirrusfb.c
@@ -2462,8 +2462,7 @@ static int __init cirrusfb_init(void)
=20
 #ifndef MODULE
 static int __init cirrusfb_setup(char *options) {
-	char *this_opt, s[32];
-	int i;
+	char *this_opt;
=20
 	DPRINTK("ENTER\n");
=20
_

Patches currently in -mm which might be from vlada.peric@gmail.com are

cirrusfb-remove-unused-variables.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
