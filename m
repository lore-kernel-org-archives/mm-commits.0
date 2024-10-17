Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F308C1CC14B
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150128; cv=none; b=kjCbzbNVBjDmIEpdwBri0Jl3EmvFVOcK61duI+iJl8Y/1kkHvFPDSFtlivSXMJxaOWKE3YIKKJDKcghkwlXI792KFhexULinW0ECsd9J8NWYMP9LZY37dEb7yvOxDiS5kGGKUIj0UYPfJeUIf7NKvTWl2ixmshg5aQdu+hVE52k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150128; c=relaxed/simple;
	bh=5phZddJM5iVtsAVewZPSskbq2OuV951q7Gi5RA0tzr8=;
	h=Date:To:From:Subject:Message-Id; b=XiRjbUv/PSe6gti3a7OPUD6UKdY6gY39yZOy2EQ5yUMBbCCS79m7oPZ3RY0JZRQnaScbLZWbuQIrG69+ReNN0R9uidn8QvAkifRpvYk/lzilQezTRiXFIUw5sEZ/av+KTynSIUklZdCtJLayZfkotG7NBxHwZB1AT2nCgmv7cfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ANKnA8GV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ANKnA8GV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2E2C4CEC3;
	Thu, 17 Oct 2024 07:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150127;
	bh=5phZddJM5iVtsAVewZPSskbq2OuV951q7Gi5RA0tzr8=;
	h=Date:To:From:Subject:From;
	b=ANKnA8GVSHioDK8uqX0TL8074uJM0DX0bbJvN/s7GSZ9BM6AjauKpb5p/dTyI/fDs
	 YKqCtjMmezNeww9YT1ytGTcmmVVz46vj5OR1Vrk5X3XN1XGLiR1X6x/d9mGpRYLRO3
	 Hos0S4v3h/T/HHZFh+8IYL/PP5m8bhxjhyRNf/Lw=
Date: Thu, 17 Oct 2024 00:28:47 -0700
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,leonchien@synology.com,greentime.hu@sifive.com,andybnac@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-an-entry-for-andy-chiu.patch removed from -mm tree
Message-Id: <20241017072847.8D2E2C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add an entry for Andy Chiu
has been removed from the -mm tree.  Its filename was
     mailmap-add-an-entry-for-andy-chiu.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Chiu <andybnac@gmail.com>
Subject: mailmap: add an entry for Andy Chiu
Date: Wed, 9 Oct 2024 22:49:34 +0800

Map my outdated addresses within mailmap.

Link: https://lkml.kernel.org/r/20241009144934.43027-1-andybnac@gmail.com
Signed-off-by: Andy Chiu <andybnac@gmail.com>
Cc: Greentime Hu <greentime.hu@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Leon Chien <leonchien@synology.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-an-entry-for-andy-chiu
+++ a/.mailmap
@@ -73,6 +73,8 @@ Andrey Ryabinin <ryabinin.a.a@gmail.com>
 Andrzej Hajda <andrzej.hajda@intel.com> <a.hajda@samsung.com>
 André Almeida <andrealmeid@igalia.com> <andrealmeid@collabora.com>
 Andy Adamson <andros@citi.umich.edu>
+Andy Chiu <andybnac@gmail.com> <andy.chiu@sifive.com>
+Andy Chiu <andybnac@gmail.com> <taochiu@synology.com>
 Andy Shevchenko <andy@kernel.org> <andy@smile.org.ua>
 Andy Shevchenko <andy@kernel.org> <ext-andriy.shevchenko@nokia.com>
 Anilkumar Kolli <quic_akolli@quicinc.com> <akolli@codeaurora.org>
_

Patches currently in -mm which might be from andybnac@gmail.com are


