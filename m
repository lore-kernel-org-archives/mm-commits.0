From: akpm@linux-foundation.org
Subject: + rio-addition-has-higher-precedence-than.patch added to -mm tree
Date: Wed, 18 Feb 2009 16:01:16 -0800
Message-ID: <200902190001.n1J01GRT020749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbZBSAB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 19:01:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     rio: addition has higher precedence than ?:
has been added to the -mm tree.  Its filename is
     rio-addition-has-higher-precedence-than.patch

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
Subject: rio: addition has higher precedence than ?:
From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rio/rio_linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/rio/rio_linux.c~rio-addition-has-higher-precedence-than drivers/char/rio/rio_linux.c
--- a/drivers/char/rio/rio_linux.c~rio-addition-has-higher-precedence-than
+++ a/drivers/char/rio/rio_linux.c
@@ -333,7 +333,7 @@ void rio_copy_to_card(void *from, void _
 
 int rio_minor(struct tty_struct *tty)
 {
-	return tty->index + (tty->driver == rio_driver) ? 0 : 256;
+	return tty->index + ((tty->driver == rio_driver) ? 0 : 256);
 }
 
 static int rio_set_real_termios(void *ptr)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
atm-bitwise-or-has-higher-precedence-than.patch
drivers-net-tg3c-fix-confusion.patch
smsc-timeout-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
paride-pgc-xs-confusion.patch
b43-bitwise-or-has-higher-precedence-than.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

