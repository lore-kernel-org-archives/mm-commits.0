From: akpm@linux-foundation.org
Subject: + update-email-addresses-in-maintainers-and-mailmap.patch added
 to -mm tree
Date: Tue, 14 Jun 2016 15:39:29 -0700
Message-ID: <576087a1.l/nXoRmS7T9lRkqk%akpm__27253.437069203$1465943982$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbcFNWja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 18:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkh@osg.samsung.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Update Shuah Khan's email addresses in MAINTAINERS and .m=
ailmap
has been added to the -mm tree.  Its filename is
     update-email-addresses-in-maintainers-and-mailmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/update-email-addresses-in-=
maintainers-and-mailmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/update-email-addresses-in-=
maintainers-and-mailmap.patch

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
=46rom: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Update Shuah Khan's email addresses in MAINTAINERS and .mailma=
p

Link: http://lkml.kernel.org/r/1465943427-11528-1-git-send-email-shuahk=
h@osg.samsung.com
Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN .mailmap~update-email-addresses-in-maintainers-and-mailmap .m=
ailmap
--- a/.mailmap~update-email-addresses-in-maintainers-and-mailmap
+++ a/.mailmap
@@ -122,6 +122,7 @@ Santosh Shilimkar <santosh.shilimkar@ora
 Sascha Hauer <s.hauer@pengutronix.de>
 S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
 Shiraz Hashim <shiraz.linux.kernel@gmail.com> <shiraz.hashim@st.com>
+Shuah Khan <shuah@kernel.org> <shuahkhan@gmail.com> <shuah.khan@hp.com=
> <shuahkh@osg.samsung.com> <shuah.kh@samsung.com>
 Simon Kelley <simon@thekelleys.org.uk>
 St=C3=A9phane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
 Stephen Hemminger <shemminger@osdl.org>
diff -puN MAINTAINERS~update-email-addresses-in-maintainers-and-mailmap=
 MAINTAINERS
--- a/MAINTAINERS~update-email-addresses-in-maintainers-and-mailmap
+++ a/MAINTAINERS
@@ -6487,6 +6487,7 @@ F:	include/uapi/linux/sunrpc/
=20
 KERNEL SELFTEST FRAMEWORK
 M:	Shuah Khan <shuahkh@osg.samsung.com>
+M:	Shuah Khan <shuah@kernel.org>
 L:	linux-kselftest@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/shuah/linux-kselftest
 S:	Maintained
@@ -11886,7 +11887,8 @@ F:	drivers/usb/common/usb-otg-fsm.c
=20
 USB OVER IP DRIVER
 M:	Valentina Manea <valentina.manea.m@gmail.com>
-M:	Shuah Khan <shuah.kh@samsung.com>
+M:	Shuah Khan <shuahkh@osg.samsung.com>
+M:	Shuah Khan <shuah@kernel.org>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	Documentation/usb/usbip_protocol.txt
_

Patches currently in -mm which might be from shuahkh@osg.samsung.com ar=
e

update-email-addresses-in-maintainers-and-mailmap.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
