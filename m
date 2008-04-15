From: akpm@linux-foundation.org
Subject: + smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch added to -mm tree
Date: Tue, 15 Apr 2008 02:11:28 -0700
Message-ID: <200804150911.m3F9BSkD020688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756798AbYDOJLi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi


The patch titled
     smb.h: uses struct timespec but didn't include linux/time.h
has been added to the -mm tree.  Its filename is
     smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: smb.h: uses struct timespec but didn't include linux/time.h
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/smb.h~smbh-uses-struct-timespec-but-didnt-inclu=
de-linux-timeh include/linux/smb.h
--- a/include/linux/smb.h~smbh-uses-struct-timespec-but-didnt-include-l=
inux-timeh
+++ a/include/linux/smb.h
@@ -11,6 +11,7 @@
=20
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/time.h>
=20
 enum smb_protocol {=20
 	SMB_PROTOCOL_NONE,=20
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

git-net.patch
fs-coda-remove-static-inline-forward-declarations.patch
i2o-remove-static-inline-forward-declarations.patch
smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
