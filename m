Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A681FDA94
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 22:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755036731; cv=none; b=lgU4KAwFGCCodrCZWk9giOlPYQCJxzKKQr1Wr3HYAoDTGM4MPNHt/fm7W2+rwSyq0y8rX0kO75reLk8c2Q40gmx5LoptOWwGH2At5Ua27zYJyX6oSEtjk7shvD2eRJc3CvockN8nWHNz/50M9RtQGyisU4QB8XAILstx0Oek83M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755036731; c=relaxed/simple;
	bh=dB3YK/86KDr0eCCOXz81s22PjCr++sG7s9u1H8dYeeA=;
	h=Date:To:From:Subject:Message-Id; b=H8PZZcLVY/TUJ7jZ1GpB+BGUMP1pVWHNyypE2lVT8r8xo/be/n4Jjes8M/CFk/s4ljmad5OE2zF64rIfNUFa5vk3+bJEXX2z7zSiUrlUJnaLgj2IKyyy3KtVEoRLCO0sL2LpqND5oOdrHRYBjQcOxblB+XsZHuYylM7Og+y4vYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cBZHRvsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cBZHRvsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB20BC4CEF0;
	Tue, 12 Aug 2025 22:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755036730;
	bh=dB3YK/86KDr0eCCOXz81s22PjCr++sG7s9u1H8dYeeA=;
	h=Date:To:From:Subject:From;
	b=cBZHRvsXvVgeHYMb8F2aPBtIs6nESEBEyd7xX2f9fG+e7wKdNu02cGDzt4d8vAi5d
	 w2S/Uf//kK456HHEvJ+mzp3jmFl3V4IZhYGAW6vUKIy+mmLU9StI5wXblgSYA0JTz5
	 m+hD0zCC5/2rmvffGGCOPd+tMIBzSGwnAIz6cjto=
Date: Tue, 12 Aug 2025 15:12:10 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,lumag@kernel.org,jarkko@kernel.org,hverkuil@kernel.org,carlos.bilbao@kernel.org,easwar.hariharan@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-easwar-hariharan.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812221210.AB20BC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: add entry for Easwar Hariharan
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-easwar-hariharan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-easwar-hariharan.patch

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
From: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Subject: .mailmap: add entry for Easwar Hariharan
Date: Tue, 12 Aug 2025 18:02:14 +0000

Map my old, obsolete work email address to my current one.

Link: https://lkml.kernel.org/r/20250812180218.92755-1-easwar.hariharan@linux.microsoft.com
Signed-off-by: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Shannon Nelson <sln@onemain.com>
Cc: Dmitry Baryshkov <lumag@kernel.org>
Cc: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-easwar-hariharan
+++ a/.mailmap
@@ -226,6 +226,8 @@ Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
 Drew Fustini <fustini@kernel.org> <drew@pdp7.com>
 <duje@dujemihanovic.xyz> <duje.mihanovic@skole.hr>
+Easwar Hariharan <easwar.hariharan@linux.microsoft.com> <easwar.hariharan@intel.com>
+Easwar Hariharan <easwar.hariharan@linux.microsoft.com> <eahariha@linux.microsoft.com>
 Ed L. Cashin <ecashin@coraid.com>
 Elliot Berman <quic_eberman@quicinc.com> <eberman@codeaurora.org>
 Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
_

Patches currently in -mm which might be from easwar.hariharan@linux.microsoft.com are

mailmap-add-entry-for-easwar-hariharan.patch

