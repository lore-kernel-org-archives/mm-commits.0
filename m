From: akpm@linux-foundation.org
Subject: + sound-remove-reference-to-feature-removal-scheduletxt.patch added to -mm tree
Date: Thu, 08 Nov 2012 12:14:48 -0800
Message-ID: <20121108201449.41905100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64551 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab2KHUOu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2012 15:14:50 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so375915yen.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Nov 2012 12:14:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: boyu.mt@taobao.com


The patch titled
     Subject: sound: remove reference to feature-removal-schedule.txt
has been added to the -mm tree.  Its filename is
     sound-remove-reference-to-feature-removal-scheduletxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: sound: remove reference to feature-removal-schedule.txt

In 9c0ece069, Linus removed feature-removal-schedule.txt from Documentation,
but there is still some reference to this file. So remove them.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/Kconfig      |    3 ---
 sound/sound_core.c |    3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN sound/Kconfig~sound-remove-reference-to-feature-removal-scheduletxt sound/Kconfig
--- a/sound/Kconfig~sound-remove-reference-to-feature-removal-scheduletxt
+++ a/sound/Kconfig
@@ -52,9 +52,6 @@ config SOUND_OSS_CORE_PRECLAIM
 
 	  Disabling this allows alternative OSS implementations.
 
-	  Please read Documentation/feature-removal-schedule.txt for
-	  details.
-
 	  If unsure, say Y.
 
 source "sound/oss/dmasound/Kconfig"
diff -puN sound/sound_core.c~sound-remove-reference-to-feature-removal-scheduletxt sound/sound_core.c
--- a/sound/sound_core.c~sound-remove-reference-to-feature-removal-scheduletxt
+++ a/sound/sound_core.c
@@ -146,8 +146,7 @@ extern int msnd_pinnacle_init(void);
  * devices only the standard chrdev aliases are requested.
  *
  * All these clutters are scheduled to be removed along with
- * sound-slot/service-* module aliases.  Please take a look at
- * feature-removal-schedule.txt for details.
+ * sound-slot/service-* module aliases.
  */
 #ifdef CONFIG_SOUND_OSS_CORE_PRECLAIM
 static int preclaim_oss = 1;
_

Patches currently in -mm which might be from boyu.mt@taobao.com are

documentation-remove-reference-to-feature-removal-scheduletxt.patch
kernel-remove-reference-to-feature-removal-scheduletxt.patch
sound-remove-reference-to-feature-removal-scheduletxt.patch
drivers-remove-reference-to-feature-removal-scheduletxt.patch

