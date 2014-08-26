From: akpm@linux-foundation.org
Subject: + init-do_mounts-better-syntax-description.patch added to -mm
 tree
Date: Tue, 26 Aug 2014 14:01:28 -0700
Message-ID: <53fcf5a8.TilcbRI5TbYbX0T4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:45014 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbaHZVB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 17:01:29 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so4003090pdj.4
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 14:01:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@denx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init/do_mounts: better syntax description
has been added to the -mm tree.  Its filename is
     init-do_mounts-better-syntax-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mounts-better-syntax-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mounts-better-syntax-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Machek <pavel@ucw.cz>
Subject: init/do_mounts: better syntax description

Specify hex device number unambiguously.

Signed-off-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-do_mounts-better-syntax-description init/do_mounts.c
--- a/init/do_mounts.c~init-do_mounts-better-syntax-description
+++ a/init/do_mounts.c
@@ -182,7 +182,8 @@ done:
 /*
  *	Convert a name into device number.  We accept the following variants:
  *
- *	1) device number in hexadecimal	represents itself
+ *	1) <hex_major><hex_minor> device number in hexadecimal represents itself
+ *         no leading 0x, for example b302.
  *	2) /dev/nfs represents Root_NFS (0xff)
  *	3) /dev/<disk_name> represents the device number of disk
  *	4) /dev/<disk_name><decimal> represents the device number
_

Patches currently in -mm which might be from pavel@ucw.cz are

input-route-kbd-leds-through-the-generic-leds-layer.patch
lib-vsprintf-add-%pt-format-specifier.patch
init-do_mounts-better-syntax-description.patch
linux-next.patch

