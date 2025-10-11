Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592042BAF9
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760206047; cv=none; b=RQ46AZ4zZrjsLAwDjqH/6zy7UxVvaVxUAp/r1lq6YzzWScZdawCQK/Nejx51TQdUneHgM6BORbbnVkg2fXfab0eHRHUcUb52gFkESwTU7lgHDXVz8tm+vD4AGNryPYmJdUnzvAJtvFynvXGS4aGyQXJpwscUcAkb9eyeY/PRquA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760206047; c=relaxed/simple;
	bh=AkFXs6DCQUsajtBiPt+Qu8G+uN6lNuXx2PA45OJUvxI=;
	h=Date:To:From:Subject:Message-Id; b=Tw2xwhKHsv1ljrOOq+w1avjPsWSeaXhdME/zp3qQ1wzC6axy3PAArv0idS0fdJ/ctVY07apCQk4gT9bJtRSqTDxSsgMgD7/pBtROkn1ESaMN5NkEozCFEZ2HCLYJ/vTv9K0Fo8vmrBVPl5XgouT797TdiarPibvIewT0J91Y/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FpLEggdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FpLEggdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85C2C4CEF4;
	Sat, 11 Oct 2025 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760206046;
	bh=AkFXs6DCQUsajtBiPt+Qu8G+uN6lNuXx2PA45OJUvxI=;
	h=Date:To:From:Subject:From;
	b=FpLEggdv5ozX9xq8+BK79JI9uQLVUWRn4RIQJVQR8RoemVVZejC4zxu1bVgmaB6r4
	 ZXbdfLruR9sHMxCUJAZb9Vv2LgpeRQnZOBq6jhcF05ytfdDMT7FtmqUBhyXMnPdqBO
	 2LWJ4Zb1UU0zl2fp1DZGmlLVHorxgy19rSK5Pqi8=
Date: Sat, 11 Oct 2025 11:07:26 -0700
To: mm-commits@vger.kernel.org,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-name-and-email-addresses.patch added to mm-nonmm-unstable branch
Message-Id: <20251011180726.B85C2C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update name and email addresses
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-name-and-email-addresses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-name-and-email-addresses.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Martin Kepplinger-Novaković <martink@posteo.de>
Subject: mailmap: update name and email addresses
Date: Sat, 11 Oct 2025 15:59:39 +0000

Apply my new surname, remove unused and update to currently used email
addresses.

Link: https://lkml.kernel.org/r/20251011155903.7442-1-martink@posteo.de
Signed-off-by: Martin Kepplinger-Novaković <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/.mailmap~mailmap-update-name-and-email-addresses
+++ a/.mailmap
@@ -494,9 +494,7 @@ Mark Brown <broonie@sirena.org.uk>
 Mark Starovoytov <mstarovo@pm.me> <mstarovoitov@marvell.com>
 Markus Schneider-Pargmann <msp@baylibre.com> <mpa@pengutronix.de>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
-Martin Kepplinger <martink@posteo.de> <martin.kepplinger@ginzinger.com>
-Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
-Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
+Martin Kepplinger-Novakovic <martink@posteo.de> <martin.kepplinger-novakovic@ginzinger.com>
 Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com> <martyna.szapar-mudlaw@intel.com>
 Mathieu Othacehe <othacehe@gnu.org> <m.othacehe@gmail.com>
 Mat Martineau <martineau@kernel.org> <mathew.j.martineau@linux.intel.com>
_

Patches currently in -mm which might be from martink@posteo.de are

mailmap-update-name-and-email-addresses.patch
credits-update-martins-information.patch
maintainers-apply-name-and-email-address-changes-for-martin.patch

