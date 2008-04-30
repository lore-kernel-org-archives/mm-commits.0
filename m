From: akpm@linux-foundation.org
Subject: - smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:07 -0700
Message-ID: <200804300541.m3U5f7KA029029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756657AbYD3Fls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ilpo.jarvinen@helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     smb.h: uses struct timespec but didn't include linux/time.h
has been removed from the -mm tree.  Its filename was
     smbh-uses-struct-timespec-but-didnt-include-linux-timeh.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
