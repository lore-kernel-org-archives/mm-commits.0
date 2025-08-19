Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E1626D4F1
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 23:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646603; cv=none; b=u+iHJZVPb725hzEbHY3P3+G/4IVPYarfgxwdznNBjERGMdvKinFxplmlXrS74dzesScP7UtvbpVLLGb7Oi2FYDLGBy5voT5/eXFON33FrgOjtkdDQ0FDbEUV30ZgdhGEaHyxe5FqpeMV058WPC+65E8g2e+pkhgE9FxTRNmy2kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646603; c=relaxed/simple;
	bh=v2Dpuc8UxckKMcuDFmGDCNj2TbhJQ81uCcEgKyotYB0=;
	h=Date:To:From:Subject:Message-Id; b=f/Dc7NUAbObI+0QMxMGJO/ysp60ynNFHl5G5pH6z6EIAPO87PwCvX0OxX2UK9S2WFAANwdeGN5ctqlUXcLq/vv9yPeTR9eB5QoqmF3p25OXJ039OO6Zv9XRLdkWp+gihL4cH9fWqHh5wpVtocEXNTvvAZcV+Bn1jRejZ1LNH+a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ucXxEcLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ucXxEcLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E387C4CEF1;
	Tue, 19 Aug 2025 23:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646603;
	bh=v2Dpuc8UxckKMcuDFmGDCNj2TbhJQ81uCcEgKyotYB0=;
	h=Date:To:From:Subject:From;
	b=ucXxEcLYBVxLSRRsxyIjYJJCl2i8u3IX1YT1Rqgo+z2VofsfJYvjiTOgnd7G3mSl3
	 sILBEb9XwCwyc22+ooOV7WYFnhnn0+Vs0gatHJSUEdaYghQ2ue1NMxvqhS1mFJTabf
	 S8GLcYjvKpdaT3rwXo6XXE5DR4PbLuOiTzHC9po8=
Date: Tue, 19 Aug 2025 16:36:40 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,lumag@kernel.org,jarkko@kernel.org,hverkuil@kernel.org,carlos.bilbao@kernel.org,easwar.hariharan@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-easwar-hariharan.patch removed from -mm tree
Message-Id: <20250819233643.7E387C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: add entry for Easwar Hariharan
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-easwar-hariharan.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


