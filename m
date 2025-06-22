Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F70BA55
	for <mm-commits@vger.kernel.org>; Sun, 22 Jun 2025 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750631527; cv=none; b=Fr7BpnbOlEPm8K2xQtGRA6Jdl27l9ad349+5Jsw/NW+8+xARjz0m+136qVWTCCCf+yYulGUdC3mx7QIuvk5Vn6b8qh9203NkbaFypbnt02jw2pch8PRyRGpObQlQKNbjUqjVOhl7d2YHLVuQtIivoPzUwRsVnz6h/bVewF7PuPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750631527; c=relaxed/simple;
	bh=oIremtXT8CDwl6P7BWrSkFCRbmMRMOqRlfnePEk4RI0=;
	h=Date:To:From:Subject:Message-Id; b=L97qmghsYHHmbe4qCu9OEuWxfosTmxeDLHZHeSVvmQeDntiHCqZbsCCHeUqZVb4YAhs+ObuBZbWo8D3tpArjR7zTV9CqZEWxjKguoZTGmz7BdWqXNyFEgYXt4plKiueRXHFNemqMMYK6s5g6c5FTIam4PJpCjIsIzd9QioacYec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mXRolS48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mXRolS48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76CBC4CEE3;
	Sun, 22 Jun 2025 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750631526;
	bh=oIremtXT8CDwl6P7BWrSkFCRbmMRMOqRlfnePEk4RI0=;
	h=Date:To:From:Subject:From;
	b=mXRolS48iP/dI92zCMEvMGPFduKvFjax4S3oj3h1wZSYEiONydB01w7e8W8TW3ciA
	 uWdwuU2Qlfk/N7K6go5dZU1gL7nNA5kiLK9ZNOKM/Yj2lEpYuBEu+pXxHqQZ1vr9Vu
	 V2X/5SMksxzitF14e865JbURttNRxFl1GwG+2kJY=
Date: Sun, 22 Jun 2025 15:32:06 -0700
To: mm-commits@vger.kernel.org,balejk@matfyz.cz,duje@dujemihanovic.xyz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-duje-mihanovics-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20250622223206.A76CBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Duje Mihanović's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-duje-mihanovics-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-duje-mihanovics-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Duje Mihanović <duje@dujemihanovic.xyz>
Subject: mailmap: update Duje Mihanović's email address
Date: Fri, 20 Jun 2025 11:25:35 +0200

I'm switching to a new mail address, so map my old one to it.

Link: https://lkml.kernel.org/r/20250620-mailmap-v1-1-a6b4b72dbd07@dujemihanovic.xyz
Signed-off-by: Duje Mihanović <duje@dujemihanovic.xyz>
Cc: Karel Balej <balejk@matfyz.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-duje-mihanovics-email-address
+++ a/.mailmap
@@ -222,6 +222,7 @@ Dmitry Safonov <0x7f454c46@gmail.com> <d
 Dmitry Safonov <0x7f454c46@gmail.com> <dsafonov@virtuozzo.com>
 Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
+<duje@dujemihanovic.xyz> <duje.mihanovic@skole.hr>
 Ed L. Cashin <ecashin@coraid.com>
 Elliot Berman <quic_eberman@quicinc.com> <eberman@codeaurora.org>
 Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
_

Patches currently in -mm which might be from duje@dujemihanovic.xyz are

mailmap-update-duje-mihanovics-email-address.patch

