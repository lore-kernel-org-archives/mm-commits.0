Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793297996;
	b=jMwjy2K7Sx67j7uiRya+7Y98areXePyLjuDct51Wmd3oookFsQERKXH8NpkzoGfip74n
	 3QbCnNVrnnME0tdG+QDDpF05tUxgLi14SLrQ8UW3wQ4vutxK1Zmq2qiQBIovp52y8gQWu
	 9IzvRBs+uwDSmvNSCJBiczYFJwEavw8S83LMwqPmp//RylgUa6g3BWlYxzHhDlMspNbrR
	 KcuAHTMhED5kDgN7lJaFSUpcKPP+cxVZw0IxkK/pEsnRRDrmoxzXqAJm4/hIJzf3ynQfL
	 vS0+JYEtoebf7lcnCzcdHe72qTWZ9iv0wpiAoiOU8uxbbCJjKWNqtn5qeqpoYWgmjJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793297996;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=gt1REbrZWlxRcD5uVTyd+WTZkYDC4BbaqT3l4SeCNVI=;
	b=UVY+OZX/tjT795g953LyIBvoxqz8syMdUKfKzFDhH1YQZDF8pO7HIYXMWv4pwg95c7TF
	 OoGaS124T+toYI4QCMDRgDXQ83uIMqnut+D16qIoIOGx0tey/Cfj+6R7Dc4WzTn64Dvye
	 RnU1ilrwhmoxjKR5ILAGBafmply+je0wKoarcY69XMFcbvcDOjIkujdkP+JutdUqiDssk
	 MtdPQ6ALZKpRbZZ5z/zIE1B3SkMN+xLoezPjVPtNPdotD/y0e3A1VZ5OfE6qs8BpqtWig
	 H/2x04xOXb6d44i9OYrRk1RR9KZ2yEHKrb4NrsyJQ1g3TLo4ZCndHssZNaA1tpqYXRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=b7Jx7Xl+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7376606A31C
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=b7Jx7Xl+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D551F01816;
	Thu, 29 Oct 2026 18:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793297995;
	bh=gt1REbrZWlxRcD5uVTyd+WTZkYDC4BbaqT3l4SeCNVI=;
	h=Date:To:From:Subject;
	b=b7Jx7Xl+CNu2JyL/bsRdYwVup5j2UKFCp0nWRUipafdRAXyDTgOg+C4kpYmXXaR4d
	 nthh6BvO27QqHO3uY3z9C7zNrVnYX/T1nE30fy5XdrGtIKJWqnO9t7PH4LAcWBIlSJ
	 lYt6iIyjIK0vSYk/tKSpiWJVaqxyHHqKfpUHfmA4=
Date: Thu, 29 Oct 2026 11:19:54 -0700
To: mm-commits@vger.kernel.org,clement.leger@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-use-clément-légers-linuxdev-mail-address.patch added to mm-nonmm-hotfixes-unstable branch
Message-Id: <20261029181955.14D551F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: mailmap: use Clément Léger's linux.dev mail address
has been added to the -mm mm-nonmm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-use-clément-légers-linuxdev-mail-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-use-clément-légers-linuxdev-mail-address.patch

This patch will later appear in the mm-nonmm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Clément Léger <clement.leger@linux.dev>
Subject: MAINTAINERS: mailmap: use Clément Léger's linux.dev mail address
Date: Thu, 29 Oct 2026 10:51:06 +0100

I recently requested a @linux.dev address so I can keep a consistent one
throughout my contributions and use it for the upcoming ones.  Map my
previously used email addresses to this new one.

Link: https://lore.kernel.org/20261029095107.24985-1-clement.leger@linux.dev
Signed-off-by: Clément Léger <clement.leger@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~maintainers-mailmap-use-clément-légers-linuxdev-mail-address
+++ a/.mailmap
@@ -233,6 +233,10 @@ Chuck Lever <cel@kernel.org> <chuck.leve
 Chuck Lever <cel@kernel.org> <cel@netapp.com>
 Chuck Lever <cel@kernel.org> <cel@citi.umich.edu>
 Claudiu Beznea <claudiu.beznea@tuxon.dev> <claudiu.beznea@microchip.com>
+Clément Léger <clement.leger@linux.dev> <cleger@kalray.eu>
+Clément Léger <clement.leger@linux.dev> <clement.leger@bootlin.com>
+Clément Léger <clement.leger@linux.dev> <cleger@rivosinc.com>
+Clément Léger <clement.leger@linux.dev> <cleger@meta.com>
 Coiby Xu <coiby.xu@gmail.com> <coxu@redhat.com>
 Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
--- a/MAINTAINERS~maintainers-mailmap-use-clément-légers-linuxdev-mail-address
+++ a/MAINTAINERS
@@ -20869,7 +20869,7 @@ S:	Maintained
 F:	drivers/char/hw_random/optee-rng.c
 
 OP-TEE RTC DRIVER
-M:	Clément Léger <clement.leger@bootlin.com>
+M:	Clément Léger <clement.leger@linux.dev>
 L:	linux-rtc@vger.kernel.org
 S:	Maintained
 F:	drivers/rtc/rtc-optee.c
@@ -23760,7 +23760,7 @@ F:	Documentation/devicetree/bindings/rtc
 F:	drivers/rtc/rtc-renesas-rtca3.c
 
 RENESAS RZ/N1 A5PSW SWITCH DRIVER
-M:	Clément Léger <clement.leger@bootlin.com>
+M:	Clément Léger <clement.leger@linux.dev>
 L:	linux-renesas-soc@vger.kernel.org
 L:	netdev@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from clement.leger@linux.dev are

maintainers-mailmap-use-clément-légers-linuxdev-mail-address.patch

