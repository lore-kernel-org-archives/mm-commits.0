From: akpm@linux-foundation.org
Subject: + maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
 added to -mm tree
Date: Mon, 27 Oct 2014 15:49:42 -0700
Message-ID: <544ecc06.iZxUB1EuBeBA4Sd1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaJ0Wtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 18:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, awalls@md.metrocast.net, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update ivtv mailing lists as subscriber-only
has been added to the -mm tree.  Its filename is
     maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update ivtv mailing lists as subscriber-only

Mark these as subscriber-only mailing lists.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-ivtv-mailing-lists-as-subscriber-only MAINTAINERS
--- a/MAINTAINERS~maintainers-update-ivtv-mailing-lists-as-subscriber-only
+++ a/MAINTAINERS
@@ -2697,7 +2697,7 @@ F:	drivers/net/wireless/cw1200/
 
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
@@ -5165,7 +5165,7 @@ F:	drivers/media/tuners/it913x*
 
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
+L:	ivtv-devel@ivtvdriver.org (subscribers-only)
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://www.ivtvdriver.org
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-ivtv-mailing-lists-as-subscriber-only.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-an-error-test-for-no-space-before-comma.patch
checkpatch-add-error-on-use-of-attributeweak-or-__weak-declarations.patch
checkpatch-improve-test-for-no-space-after-cast.patch
checkpatch-improve-warning-message-for-needless-if-case.patch
checkpatch-fix-use-via-symlink-make-missing-spelling-file-non-fatal.patch
binfmt_misc-add-comments-debug-logs.patch
binfmt_misc-clean-up-code-style-a-bit.patch
fs-affs-amigaffsc-use-va_format-instead-of-buffer-vnsprintf.patch
linux-next.patch

