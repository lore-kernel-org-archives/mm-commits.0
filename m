From: akpm@linux-foundation.org
Subject: [merged] update-speakup-mailing-list-address.patch removed from
 -mm tree
Date: Mon, 21 Jul 2014 12:34:33 -0700
Message-ID: <53cd6b49.tZr9dVqUI8d+haa4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:37784 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568AbaGUTef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 15:34:35 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so2428583iec.1
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 12:34:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update speakup mailing list address
has been removed from the -mm tree.  Its filename was
     update-speakup-mailing-list-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: MAINTAINERS: update speakup mailing list address

The speakup mailing list only works on the linux-speakup.org domain now.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |    2 +-
 drivers/staging/speakup/TODO |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~update-speakup-mailing-list-address MAINTAINERS
--- a/MAINTAINERS~update-speakup-mailing-list-address
+++ a/MAINTAINERS
@@ -8645,7 +8645,7 @@ M:	William Hubbs <w.d.hubbs@gmail.com>
 M:	Chris Brannon <chris@the-brannons.com>
 M:	Kirk Reiser <kirk@reisers.ca>
 M:	Samuel Thibault <samuel.thibault@ens-lyon.org>
-L:	speakup@braille.uwo.ca
+L:	speakup@linux-speakup.org
 W:	http://www.linux-speakup.org/
 S:	Odd Fixes
 F:	drivers/staging/speakup/
diff -puN drivers/staging/speakup/TODO~update-speakup-mailing-list-address drivers/staging/speakup/TODO
--- a/drivers/staging/speakup/TODO~update-speakup-mailing-list-address
+++ a/drivers/staging/speakup/TODO
@@ -1,6 +1,6 @@
 Speakup project home:  http://www.linux-speakup.org
 
-Mailing List:  speakup@braille.uwo.ca
+Mailing List:  speakup@linux-speakup.org
 
 Speakup is a kernel based screen review package for the linux operating
 system.  It allows blind users to interact with applications on the
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

input-route-kbd-leds-through-the-generic-leds-layer.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
linux-next.patch

