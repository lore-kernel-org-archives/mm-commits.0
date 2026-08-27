Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C17735C68B
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 20:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861324; cv=none; b=MSpBMqHUxTt3j+C3wBL/OwdcsPiHxeSEw44km7JhAjVh2+ud9ekrdNtU6yJFCaLj9i6QrbqwHPoLqMPBkGs0ueUZo2+SO5FaThIlzoGKUqf8wv7YWv4KrUwunqndpgKHwA585nDhZPbK70zWRSwg7wISBRs4dTgRCjv2oOAVCpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861324; c=relaxed/simple;
	bh=mDdCpqcnmxGP4eZqEubh//G0SI27b/JzoorZao/7oAs=;
	h=Date:To:From:Subject:Message-Id; b=f8ss3p7WUJKFhfpmu7fFs0GZShpOOHkYj4/SI/DazjkmCmdyADjYTfxwktsGSuoBrDzv0USSrhwQkBrLVcVtVdwZAGisBpcNIY2mzP7uFtxDzLQQQRIPU0AF7mfB17knE/H6ML6LFh92Qdg6QJad1F/KrK72/OmwZP3gk2K4zwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vl44frPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vl44frPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1F81F000E9;
	Thu, 27 Aug 2026 20:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861322;
	bh=f3v+zc/R/nKoYYtlJIwtP65tVHsNC8ZrN07r8FQqNRQ=;
	h=Date:To:From:Subject;
	b=vl44frPibSmut4hc8cK6M638qvgwdfNFve5/HXQuLJa5a94xTF29G30Wr0iSMLybG
	 H40FHvzTsJ27rA3tsOuMKAjLce4wzvmzpeIgoaokpHf2s60N8p8xlFCrJjuqIrJ8Qz
	 3w3rR4K297ABwAaqDxnH0piVKPNoWKifrGZVXSRc=
Date: Thu, 27 Aug 2026 13:08:41 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,kuba@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-entries-for-thorsten-blum.patch removed from -mm tree
Message-Id: <20260827200842.5F1F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mailmap: update entries for Thorsten Blum
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-entries-for-thorsten-blum.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <blum@kernel.org>
Subject: MAINTAINERS: mailmap: update entries for Thorsten Blum
Date: Tue, 25 Aug 2026 18:49:27 +0200

Map my previously used email addresses to blum@kernel.org.

Link: https://lore.kernel.org/20260825164933.105605-2-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-entries-for-thorsten-blum
+++ a/.mailmap
@@ -891,7 +891,8 @@ Thomas Graf <tgraf@suug.ch>
 Thomas Gleixner <tglx@kernel.org> <tglx@linutronix.de>
 Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
-Thorsten Blum <thorsten.blum@linux.dev> <thorsten.blum@toblux.com>
+Thorsten Blum <blum@kernel.org> <thorsten.blum@toblux.com>
+Thorsten Blum <blum@kernel.org> <thorsten.blum@linux.dev>
 Tiezhu Yang <yangtiezhu@loongson.cn> <kernelpatch@126.com>
 Tingwei Zhang <quic_tingwei@quicinc.com> <tingwei@codeaurora.org>
 Tirupathi Reddy <quic_tirupath@quicinc.com> <tirupath@codeaurora.org>
--- a/MAINTAINERS~maintainers-mailmap-update-entries-for-thorsten-blum
+++ a/MAINTAINERS
@@ -17678,7 +17678,7 @@ F:	Documentation/devicetree/bindings/ser
 F:	drivers/spi/spi-at91-usart.c
 
 MICROCHIP ATSHA204A DRIVER
-M:	Thorsten Blum <thorsten.blum@linux.dev>
+M:	Thorsten Blum <blum@kernel.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/atmel-sha204a.c
@@ -17702,7 +17702,7 @@ F:	Documentation/devicetree/bindings/med
 F:	drivers/media/platform/microchip/microchip-csi2dc.c
 
 MICROCHIP ECC DRIVER
-M:	Thorsten Blum <thorsten.blum@linux.dev>
+M:	Thorsten Blum <blum@kernel.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/atmel-ecc.c
_

Patches currently in -mm which might be from blum@kernel.org are

init-fix-early-boot-crash-with-bare-hostname-parameter.patch

