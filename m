From: akpm@linux-foundation.org
Subject: + maintainers-remove-drivers-char-hpetc.patch added to -mm tree
Date: Tue, 24 Aug 2010 15:42:10 -0700
Message-ID: <201008242242.o7OMgAWX019097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283Ab0HXWmZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Aug 2010 18:42:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, bpicco@redhat.com


The patch titled
     MAINTAINERS: remove drivers/char/hpet.c
has been added to the -mm tree.  Its filename is
     maintainers-remove-drivers-char-hpetc.patch

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
Subject: MAINTAINERS: remove drivers/char/hpet.c
From: Jiri Slaby <jslaby@suse.cz>

bob.picco@hp.com doesn't work any more and Bob says that he's unlikely to
work on hpet.c in the future.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Bob Picco <bpicco@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-drivers-char-hpetc MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drivers-char-hpetc
+++ a/MAINTAINERS
@@ -2776,11 +2776,6 @@ S:	Maintained
 F:	arch/x86/kernel/hpet.c
 F:	arch/x86/include/asm/hpet.h
 
-HPET:	ACPI
-M:	Bob Picco <bob.picco@hp.com>
-S:	Maintained
-F:	drivers/char/hpet.c
