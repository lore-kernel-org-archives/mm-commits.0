From: akpm@linux-foundation.org
Subject: + maintainers-add-irq-subsystem.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:16:43 -0700
Message-ID: <201009110016.o8B0GhwY011322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab0IKARB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, hpa@zytor.com, jkosina@suse.cz, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     MAINTAINERS: Add IRQ SUBSYSTEM
has been added to the -mm tree.  Its filename is
     maintainers-add-irq-subsystem.patch

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
Subject: MAINTAINERS: Add IRQ SUBSYSTEM
From: Joe Perches <joe@perches.com>

To make it easier on others, maybe Thomas should add his name
to MAINTAINERS because kernel/irq currently has no listed MAINTAINER.

$ ./scripts/get_maintainer.pl --nogit --roles -f kernel/irq
linux-kernel@vger.kernel.org (open list)

$ ./scripts/get_maintainer.pl --git --rolestats -f kernel/irq
Thomas Gleixner <tglx@linutronix.de> (commit_signer:19/39=49%)
Jiri Kosina <jkosina@suse.cz> (commit_signer:5/39=13%)
"H. Peter Anvin" <hpa@zytor.com> (commit_signer:4/39=10%)
Yinghai Lu <yinghai@kernel.org> (commit_signer:4/39=10%)
Ingo Molnar <mingo@elte.hu> (commit_signer:3/39=8%)
linux-kernel@vger.kernel.org (open list)

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~maintainers-add-irq-subsystem MAINTAINERS
--- a/MAINTAINERS~maintainers-add-irq-subsystem
+++ a/MAINTAINERS
@@ -3225,6 +3225,14 @@ F:	drivers/net/irda/
 F:	include/net/irda/
 F:	net/irda/
 
+IRQ SUBSYSTEM
+M:	Thomas Gleixner <tglx@linutronix.de>
+S:	Maintained
+F:	Documentation/IRQ*.txt
+F:	include/linux/interrupt.h
+F:	include/linux/irq.h
+F:	kernel/irq/
+
 ISAPNP
 M:	Jaroslav Kysela <perex@perex.cz>
 S:	Maintained
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-add-irq-subsystem.patch
kernelh-add-minmax3-macros.patch
kernelh-add-minmax3-macros-fix.patch
replace-nested-max-min-macros-with-maxmin3-macro.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-add-additional-attribute-defines.patch
scripts-checkpatchpl-add-warnings-for-static-char-that-could-be-static-const-char.patch

