Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C197A3B47FD
	for <mm-commits@vger.kernel.org>; Wed, 26 Aug 2026 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787779408; cv=none; b=NtuleuT7Ic1ZHkqj1MNyhH9il8v1UezwcPnWivjkR5xl1rKTApxG5jEHlqWL7XzbqogtG/AHz/SJlrwxEOV7zJ0sdUpjedsYPGS9XfHLrOjCLxy9ANh7kQlf0kKxR1XJZcUVsfJ8YELA56mbfAJY0MIysRgSUy46ydhFcqhdIqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787779408; c=relaxed/simple;
	bh=4JS+gPC3dkDqWu4+U1EQRIbpxylwCFOKM6HSn0KebYc=;
	h=Date:To:From:Subject:Message-Id; b=cQvRZOvSQ4VVqMYkkpXUQE2joBgBSQ3hRRdRfCfWKxKFI6ucX622UdRdlmCAfoUcVQaEuefVK3GvXMujzhXvkN7PAcCfllEHBr+9aHbLUiZH+sTg/Z/ko01Le45a+Dv1JhufB1CZgRTXidOwP6mHGazNswJXVxWVOquQkpNBqr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=comeuBT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="comeuBT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC11F000E9;
	Wed, 26 Aug 2026 21:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787779406;
	bh=VH5/23ApCiKv+Q3m2yAQ7j26jpc33mtvZEhJhO/ocrE=;
	h=Date:To:From:Subject;
	b=comeuBT0esNveAGnpKThMtlSLTF0DGkKJ0imyKGLSQMRmKgwyeJfzsiYNjOdNy7S7
	 qnpuTVefhWWc7GT8RjubmmA+OwjSHCgSrZN207wpjCFkoM70H9VC51EYJYLki48AoN
	 e1mC10So09tVXsUFPLCVgv0bxCv31qHF5nIjEUKc=
Date: Wed, 26 Aug 2026 14:23:25 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,kuba@kernel.org,blum@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-entries-for-thorsten-blum.patch added to mm-hotfixes-unstable branch
Message-Id: <20260826212326.40DC11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mailmap: update entries for Thorsten Blum
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-entries-for-thorsten-blum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-entries-for-thorsten-blum.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -878,7 +878,8 @@ Thomas Graf <tgraf@suug.ch>
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
@@ -17529,7 +17529,7 @@ F:	Documentation/devicetree/bindings/ser
 F:	drivers/spi/spi-at91-usart.c
 
 MICROCHIP ATSHA204A DRIVER
-M:	Thorsten Blum <thorsten.blum@linux.dev>
+M:	Thorsten Blum <blum@kernel.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/atmel-sha204a.c
@@ -17553,7 +17553,7 @@ F:	Documentation/devicetree/bindings/med
 F:	drivers/media/platform/microchip/microchip-csi2dc.c
 
 MICROCHIP ECC DRIVER
-M:	Thorsten Blum <thorsten.blum@linux.dev>
+M:	Thorsten Blum <blum@kernel.org>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	drivers/crypto/atmel-ecc.c
_

Patches currently in -mm which might be from blum@kernel.org are

maintainers-mailmap-update-entries-for-thorsten-blum.patch

