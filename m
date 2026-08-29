Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC5355048
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788026521; cv=none; b=o6Ob4ageWx77aDHXcQAnxZPhhqXXsnK4LALQbBnuOCqmmCoR5Gpf4o96suJAObsRSOU4OfI4hrFKebVLpXR9WAqCgfDDJ1t/uuCoIiJg0U/4IQGa4iFH96zKlcrpclNorrNv6f2JpBLPFzppxuCSITZH+WZUDg15SCi12PyIPx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788026521; c=relaxed/simple;
	bh=SON13pzBK1bdt5po5zgwDWu1UED0ecib1C5pAUmv1j4=;
	h=Date:To:From:Subject:Message-Id; b=PXfTM8fDYwtR90ydPWK+851nwb8fHKw775x/z3pjtlUKAks7YIJBzFOJsLdiAasuFvNJjt8eY+EyBw87Kfk94UrthVNUb0dLYg3SH9GLil5xSFzJhEzNp3oJ6REdaVVnp7r7JWi0DvqQz15/fhuDoFHlg+PTl49k3gjGKZOMvvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VVt5ks5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VVt5ks5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA0E1F000E9;
	Sat, 29 Aug 2026 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788026520;
	bh=HKVR5dXpLtdjbjvgdvJqD8mZYZi+y2iNdrcsWaoHwW4=;
	h=Date:To:From:Subject;
	b=VVt5ks5skF2EF27B0cdsZu5tglzqzBqXU78Stl16lTTbnnkUBSBRTq3DwUV8ky0de
	 BjJaCCdtTyYmti7vrx1u6k3gwKh7rHvfdthskaUviuqMjDtxTA61OLWTZ9nNLd3Sz3
	 ZwGVsyb7j7H5P02jTpdOMhpkh5V8Nue82+wT+oic=
Date: Sat, 29 Aug 2026 11:01:59 -0700
To: mm-commits@vger.kernel.org,chris.obbard@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-entry-for-christopher-obbard.patch added to mm-hotfixes-unstable branch
Message-Id: <20260829180200.3EA0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update entry for Christopher Obbard
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-entry-for-christopher-obbard.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-entry-for-christopher-obbard.patch

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
From: Christopher Obbard <chris.obbard@oss.qualcomm.com>
Subject: mailmap: update entry for Christopher Obbard
Date: Sat, 29 Aug 2026 12:28:23 +0100

I have changed employer; update my mailmap entry to point at my new email
address.

Link: https://lore.kernel.org/20260829-update-mail-oss-qualcomm-v2-1-1670c515f225@oss.qualcomm.com
Signed-off-by: Christopher Obbard <chris.obbard@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-entry-for-christopher-obbard
+++ a/.mailmap
@@ -210,7 +210,8 @@ Christophe Leroy <chleroy@kernel.org> <c
 Christophe Leroy <chleroy@kernel.org> <christophe.leroy@csgroup.eu>
 Christophe Leroy <chleroy@kernel.org> <christophe.leroy2@cs-soprasteria.com>
 Christophe Ricard <christophe.ricard@gmail.com>
-Christopher Obbard <christopher.obbard@linaro.org> <chris.obbard@collabora.com>
+Christopher Obbard <chris.obbard@oss.qualcomm.com> <chris.obbard@collabora.com>
+Christopher Obbard <chris.obbard@oss.qualcomm.com> <christopher.obbard@linaro.org>
 Christoph Hellwig <hch@lst.de>
 Christoph Manszewski <c.manszewski@gmail.com> <christoph.manszewski@intel.com>
 Christoph Paasch <cpaasch@openai.com> <christoph.paasch@gmail.com>
_

Patches currently in -mm which might be from chris.obbard@oss.qualcomm.com are

mailmap-update-entry-for-christopher-obbard.patch

