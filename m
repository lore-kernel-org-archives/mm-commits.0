From: akpm@linux-foundation.org
Subject: + vsnprintf-fix-reference-for-compressed-ipv6-addresses.patch added to -mm tree
Date: Tue, 22 Dec 2009 14:07:41 -0800
Message-ID: <200912222207.nBMM7f5r027232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbZLVWIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 17:08:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, davem@davemloft.net, joe@perches.com, joy@entuzijast.net


The patch titled
     vsnprintf: fix reference for compressed ipv6 addresses
has been added to the -mm tree.  Its filename is
     vsnprintf-fix-reference-for-compressed-ipv6-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: vsnprintf: fix reference for compressed ipv6 addresses
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Reported-by: Josip Rodin <joy@entuzijast.net>
Cc: Joe Perches <joe@perches.com>
Cc: David S. Miller <davem@davemloft.net>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~vsnprintf-fix-reference-for-compressed-ipv6-ad=
dresses lib/vsprintf.c
--- a/lib/vsprintf.c~vsnprintf-fix-reference-for-compressed-ipv6-addres=
ses
+++ a/lib/vsprintf.c
@@ -903,7 +903,7 @@ static char *uuid_string(char *buf, char
  *       IPv6 omits the colons (01020304...0f)
  *       IPv4 uses dot-separated decimal with leading 0's (010.123.045=
=2E006)
  * - 'I6c' for IPv6 addresses printed as specified by
- *       http://www.ietf.org/id/draft-kawamura-ipv6-text-representatio=
n-03.txt
+ *       http://tools.ietf.org/html/draft-ietf-6man-text-addr-represen=
tation-00
  * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
  *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  *       Options for %pU are:
@@ -1188,7 +1188,7 @@ qualifier:
  * %pI6 print an IPv6 address with colons
  * %pi6 print an IPv6 address without colons
  * %pI6c print an IPv6 address as specified by
- *   http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03=
=2Etxt
+ *   http://tools.ietf.org/html/draft-ietf-6man-text-addr-representati=
on-00
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or =
upper
  *   case.
  * %n is ignored
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
vsnprintf-fix-reference-for-compressed-ipv6-addresses.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
