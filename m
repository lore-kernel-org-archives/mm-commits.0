Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE7A20EA27
	for <mm-commits@vger.kernel.org>; Fri, 25 Oct 2024 22:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729895933; cv=none; b=BGjvBEuYSUtql7RKTV5J/BhOdEQqUlgGbjpD09jhRBlSGA5Wc0diWTwxIEl+w/daQ+AG47uAD7VcVfy36KlsTyg89Z6zc8NkInVB83uLKTFGmdFtbcpBwo+hRGQJJLhgZGO4OqwZ0up1X99C1OI90geKns/hVJ9QfdB0pDH98yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729895933; c=relaxed/simple;
	bh=aUMTf7zHGBkquExcCt/ay0G5CI9Ho4BrW5Ej0dvxhFM=;
	h=Date:To:From:Subject:Message-Id; b=Ea67bmrsveAM9jctLPyZoJtD/EticTUoAOwO6aMBouh5700zKia5oK+lUrQZhEr2wbZAN9+YBCke8lzfYBWOqC/BaYFCRszL9zLdgB/KCfGq0gZQgfG+BuEGi2mKcRF014lA7X26IGKT1XPCVvDmTTLBjetxeLDaa/L4Tu9JQC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l2KKhQVp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l2KKhQVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64AA5C4CECD;
	Fri, 25 Oct 2024 22:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729895932;
	bh=aUMTf7zHGBkquExcCt/ay0G5CI9Ho4BrW5Ej0dvxhFM=;
	h=Date:To:From:Subject:From;
	b=l2KKhQVpb8MpJHTtp+NvELynN6LFbsDAneLstkDhBUGNCpv/1hDX24LMrPu1Ps0Be
	 GRdkjzn9sqYjgWMZfR6RFitF7Ur4rqVZUm0Gj+Okm6FkeYcXOp6mPBLSJJ5Q54ApYF
	 hsgZwn+RUnDwz19a9R1fVoWvHDQk5tdwmyyPgA64=
Date: Fri, 25 Oct 2024 15:38:51 -0700
To: mm-commits@vger.kernel.org,eugen.hristev@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-e-mail-address-for-eugen-hristev.patch added to mm-hotfixes-unstable branch
Message-Id: <20241025223852.64AA5C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: .mailmap: update e-mail address for Eugen Hristev
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-e-mail-address-for-eugen-hristev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-e-mail-address-for-eugen-hristev.patch

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
From: Eugen Hristev <eugen.hristev@linaro.org>
Subject: .mailmap: update e-mail address for Eugen Hristev
Date: Fri, 25 Oct 2024 11:58:48 +0300

Update e-mail address.

Link: https://lkml.kernel.org/r/20241025085848.483149-1-eugen.hristev@linaro.org
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-e-mail-address-for-eugen-hristev
+++ a/.mailmap
@@ -199,7 +199,8 @@ Elliot Berman <quic_eberman@quicinc.com>
 Enric Balletbo i Serra <eballetbo@kernel.org> <enric.balletbo@collabora.com>
 Enric Balletbo i Serra <eballetbo@kernel.org> <eballetbo@iseebcn.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
-Eugen Hristev <eugen.hristev@collabora.com> <eugen.hristev@microchip.com>
+Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@microchip.com>
+Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@collabora.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> <ezequiel@collabora.com>
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason@jlekstrand.net>
_

Patches currently in -mm which might be from eugen.hristev@linaro.org are

mailmap-update-e-mail-address-for-eugen-hristev.patch

