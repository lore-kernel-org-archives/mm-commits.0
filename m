From: akpm@linux-foundation.org
Subject: + update-speakup-mailing-list-address.patch added to -mm tree
Date: Thu, 17 Jul 2014 14:41:16 -0700
Message-ID: <53c842fc.ac/KruYpLAVeNTJJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:60266 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaGQVlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jul 2014 17:41:17 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so426153yha.4
        for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2014 14:41:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update speakup mailing list address
has been added to the -mm tree.  Its filename is
     update-speakup-mailing-list-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/update-speakup-mailing-list-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/update-speakup-mailing-list-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
update-speakup-mailing-list-address.patch

