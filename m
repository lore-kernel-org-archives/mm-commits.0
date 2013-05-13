From: akpm@linux-foundation.org
Subject: + insert-missing-space-in-printk-line-of-root_delay.patch added to -mm tree
Date: Mon, 13 May 2013 15:53:32 -0700
Message-ID: <20130513225332.6B86B31C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:55815 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3EMWxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 May 2013 18:53:33 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so666234yen.3
        for <mm-commits@vger.kernel.org>; Mon, 13 May 2013 15:53:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toralf.foerster@gmx.de


The patch titled
     Subject: insert missing space in printk line of root_delay
has been added to the -mm tree.  Its filename is
     insert-missing-space-in-printk-line-of-root_delay.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Toralf F=F6rster <toralf.foerster@gmx.de>
Subject: insert missing space in printk line of root_delay

Trivial, but it really looks better.

Signed-off-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts.c~insert-missing-space-in-printk-line-of-root_=
delay init/do_mounts.c
--- a/init/do_mounts.c~insert-missing-space-in-printk-line-of-root_dela=
y
+++ a/init/do_mounts.c
@@ -536,7 +536,7 @@ void __init prepare_namespace(void)
 	int is_floppy;
=20
 	if (root_delay) {
-		printk(KERN_INFO "Waiting %dsec before mounting root device...\n",
+		printk(KERN_INFO "Waiting %d sec before mounting root device...\n",
 		       root_delay);
 		ssleep(root_delay);
 	}
_

Patches currently in -mm which might be from toralf.foerster@gmx.de are

insert-missing-space-in-printk-line-of-root_delay.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
