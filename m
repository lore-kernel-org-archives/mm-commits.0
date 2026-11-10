Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794341662;
	b=ho9Kg8XFeRMqtq8fdvxjhjBatCixHrX/E7+yFi1JjH8SRsingO/6+2+qD0/oxsDfdx4e
	 M3nkMTAKdIbSvNaNV3OwW51h5siuNRyetTmaO3qOBCJcxZnawA1lCV6KjJEJd1bvX+JhS
	 kNkeI7gfv0T3DPZ1iKUE0cSXhoyWoYNQiZl/dFXPZuoGsm0rwJ3VytH3eaK1d7vbnh1PC
	 LHKv3ieUbxh8zzWYoJzgJzXEEbeLc0vRYcdgdXj5ZolcekPhfAZv3drmqVnw+rxiJ5sHp
	 1oPgyLpb58cJuDj3YCpxzFdbuYxpIm2tuWE7kNJ5xTLtBe/IRJrvn5Gh6tKbAZ2rlVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794341662;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BdkzqQXkXctdi6L30kSWC7WHXhULnRAhsEWCgmRhDvI=;
	b=o5GNdPtfwmX784m7NhAu21AyaxbKCR5jxMKLlcaJes/x73ucS9GFq/RhN4U+5RUJ6BIb
	 fv8AwqchIOxhdSiO1OEDsg+BI02ftP4sJcqo4EJN8GzWWwOKK79MMx6ZGBs0GsLKRNKYJ
	 3XU4q+ijoFwfvLc0Srop5dueYE3tqJAgpKMcJlowP5lS3e0PUbR3SD02Fmfc7OsGa3O1r
	 Xzdj3l5+uqGa1lxbGkYtTqSL/vIT19ZdIBaNw0JvOZKWnXvE/Ry9UulceheKUi/pdmOF0
	 xidq3U54ATilmy5Tt2pLjFuG8vt57V0uz6AkPGTuo+bonsdY+PVGLgFDxp4b0NrRXvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CtNvyJoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A019606A320
	for <mm-commits@vger.kernel.org>; Tue, 10 Nov 2026 20:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CtNvyJoP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025821F008A1;
	Tue, 10 Nov 2026 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794341662;
	bh=BdkzqQXkXctdi6L30kSWC7WHXhULnRAhsEWCgmRhDvI=;
	h=Date:To:From:Subject;
	b=CtNvyJoPjwEwRrprQr7QXS1kObVvDzCwSfPEiOSHxFc3AJftmbTTTqaucwUed39Oc
	 HByNQahOkBJrU9onSD8Fpj5utyoq2TScx/j2M7Wft3uB6LPS42FG/+J7L5L8zFUb9O
	 GbMpVE4nPAd21eZkQZsoG2rFfcwk9ua6c171XBlg=
Date: Tue, 10 Nov 2026 12:14:21 -0800
To: mm-commits@vger.kernel.org,kuba@kernel.org,elder@kernel.org,
	elder@riscstar.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-an-alias-for-alex-elder.patch added to mm-nonmm-unstable branch
Message-Id: <20261110201422.025821F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add an alias for Alex Elder
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-an-alias-for-alex-elder.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-an-alias-for-alex-elder.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alex Elder <elder@riscstar.com>
Subject: mailmap: add an alias for Alex Elder
Date: Tue, 10 Nov 2026 08:42:47 -0600

Add an entry to .mailmap to indicate that <elder@riscstar.com> represents
the same person as <elder@kernel.org>.

Link: https://lore.kernel.org/20261110144250.656840-1-elder@riscstar.com
Signed-off-by: Alex Elder <elder@riscstar.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alex Elder <elder@kernel.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-an-alias-for-alex-elder
+++ a/.mailmap
@@ -64,6 +64,7 @@ Alex Elder <elder@kernel.org> <elder@iee
 Alex Elder <elder@kernel.org> <elder@inktank.com>
 Alex Elder <elder@kernel.org> <elder@linaro.org>
 Alex Elder <elder@kernel.org> <elder@newdream.net>
+Alex Elder <elder@kernel.org> <elder@riscstar.com>
 Alex Hung <alexhung@gmail.com> <alex.hung@canonical.com>
 Alex Shi <alexs@kernel.org> <alex.shi@intel.com>
 Alex Shi <alexs@kernel.org> <alex.shi@linaro.org>
_

Patches currently in -mm which might be from elder@riscstar.com are

mailmap-add-an-alias-for-alex-elder.patch

