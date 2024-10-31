Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280B61BD9E8
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 03:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344521; cv=none; b=fY53U5bhgftVv7KJOW6HF4Cz9hLhTRRT2u46DOtcVlUCNxay/06Aom7eUKLLOWJbi9KAzVHRuKsUjBF5DKE6FH06qz9pJGvBIfMSD1tVdPI1qDen5IHMF0H6Zj4jQjKQpX0PjOLz/RoJON3fcpc6Fm0/X6uJlVWn7K1T4M3EC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344521; c=relaxed/simple;
	bh=nutvKZYSY9/BhojwbSDvOwwYekxR8PB67UtAtv2KFeo=;
	h=Date:To:From:Subject:Message-Id; b=XWEmpqOKWJbTA/gwbon3XtALGeZHUJWQCXRHeTJx0Go6BuUC4ssx9sIvdRfxgZoXBT7hgBcODbio+OgKES7z4FJstnTgouPKhGMzfcAESDbuLpK6njuBDdTB0aFnBxu4lQQUickZlMdLemN+lEMcWGZqMXukWNG5kD4L9iXdl9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q3Oqr2z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q3Oqr2z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB6FC4CECF;
	Thu, 31 Oct 2024 03:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344521;
	bh=nutvKZYSY9/BhojwbSDvOwwYekxR8PB67UtAtv2KFeo=;
	h=Date:To:From:Subject:From;
	b=q3Oqr2z4AKi9/Am2CBsagBstWZLBAtqSMxApSodLGQ74VC1RJDuBf6cv8eU/Hav8J
	 xoQfzB2jzb/CvD8UvW+UOdgUXtiP4oYN/mja2PylNXJTPh2lhUve3qk4F5k6pTBxhB
	 DozNQbktyZD0XsE9h6u8OByZ1lBKv94C7ez18y8w=
Date: Wed, 30 Oct 2024 20:15:20 -0700
To: mm-commits@vger.kernel.org,eugen.hristev@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-e-mail-address-for-eugen-hristev.patch removed from -mm tree
Message-Id: <20241031031520.EDB6FC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: update e-mail address for Eugen Hristev
has been removed from the -mm tree.  Its filename was
     mailmap-update-e-mail-address-for-eugen-hristev.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


