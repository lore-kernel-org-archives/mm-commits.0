From: akpm@linux-foundation.org
Subject: + maintainers-kexec-tools-has-moved.patch added to -mm tree
Date: Wed, 18 Aug 2010 15:57:56 -0700
Message-ID: <201008182257.o7IMvuE1016846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760Ab0HRW6F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 18:58:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com


The patch titled
     MAINTAINERS: kexec-tools has moved
has been added to the -mm tree.  Its filename is
     maintainers-kexec-tools-has-moved.patch

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
Subject: MAINTAINERS: kexec-tools has moved
From: Simon Horman <horms@verge.net.au>

Kexec tools has been moved to http://kernel.org/pub/linux/utils/kernel/kexec/
as user-space code shouldn't be in /pub/linux/kernel

Signed-off-by: Simon Horman <horms@verge.net.au>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-kexec-tools-has-moved MAINTAINERS
--- a/MAINTAINERS~maintainers-kexec-tools-has-moved
+++ a/MAINTAINERS
@@ -3401,7 +3401,7 @@ F:	drivers/s390/kvm/
 
 KEXEC
 M:	Eric Biederman <ebiederm@xmission.com>
-W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
+W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
_

Patches currently in -mm which might be from horms@verge.net.au are

maintainers-kexec-tools-has-moved.patch

