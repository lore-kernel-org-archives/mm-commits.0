From: akpm@linux-foundation.org
Subject: + viafb-documentation-update.patch added to -mm tree
Date: Mon, 07 Dec 2009 13:32:31 -0800
Message-ID: <200912072132.nB7LWVBE001840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935606AbZLGVdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 16:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm


The patch titled
     viafb: documentation update
has been added to the -mm tree.  Its filename is
     viafb-documentation-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: documentation update
From: Harald Welte <laforge@gnumonks.org>

We now support the VX855, and the VX800 is no longer unaccellerated.
viafb_video_dev was removed as it was useless.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/viafb.txt |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN Documentation/fb/viafb.txt~viafb-documentation-update Documentation/fb/viafb.txt
--- a/Documentation/fb/viafb.txt~viafb-documentation-update
+++ a/Documentation/fb/viafb.txt
@@ -7,7 +7,7 @@
     VIA UniChrome Family(CLE266, PM800 / CN400 / CN300,
                         P4M800CE / P4M800Pro / CN700 / VN800,
                         CX700 / VX700, K8M890, P4M890,
-                        CN896 / P4M900, VX800)
+                        CN896 / P4M900, VX800, VX855)
 
 [Driver features]
 ------------------------
@@ -154,13 +154,6 @@
         0 : No Dual Edge Panel (default)
         1 : Dual Edge Panel
 
-    viafb_video_dev:
-        This option is used to specify video output devices(CRT, DVI, LCD) for
-        duoview case.
-        For example:
-        To output video on DVI, we should use:
-            modprobe viafb viafb_video_dev=DVI...
