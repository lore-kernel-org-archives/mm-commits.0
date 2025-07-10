Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697F2286D60
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127183; cv=none; b=Bt7Ef032uS1toyijp5N4v6c5HsFSbwaERgKeLR1k3m+TjXtmIdinIOj3VEBhElbQBiTFIj0y8yH+sJqbp9e5jtCW3DanFL0y2jFaSPNw2z4Ap3RSmGdpJPMOK2ndqb5hvrxrk2j86vMtfSUiiJ4E9hzVat2Gix3XNPjrZzXLwy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127183; c=relaxed/simple;
	bh=aPXZTvoI/DRiJ34xY/EbjzlRmIW/6ZgW6IiDEvQg6/s=;
	h=Date:To:From:Subject:Message-Id; b=TGGxwkWnED5UXyWJEWHMjd1GVtPiwpZKZWZyzUw+Hb8qeDhYEad3KaQq7wQLVZPVjFeCSBgxRKrrA8rSUnMFmmX8i9Gv+138oSymk84g6pWzRoF8y9MA6WFfY+crBjtQLmuUUAOZCqlPuboRH96CGJvvs5thbqDhk4ECPLqt1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u6o/Vg+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u6o/Vg+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6DBC4CEE3;
	Thu, 10 Jul 2025 05:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127183;
	bh=aPXZTvoI/DRiJ34xY/EbjzlRmIW/6ZgW6IiDEvQg6/s=;
	h=Date:To:From:Subject:From;
	b=u6o/Vg+6RPg7R2779DG1Efwf+Kkbiu0GpgBOXYmjpaX+gVaRLgQb/Xrsz2jx+4Pi6
	 U8fv250XHRI3OVJwgLDu8N+6f9Fo5PzPa59gJ09/22ri0M34lIux6AfnzD/yft4xwy
	 UaUrdXOPGLx6PBsAHaXgvDTEydYM/64Ldjk7IlAQ=
Date: Wed, 09 Jul 2025 22:59:42 -0700
To: mm-commits@vger.kernel.org,sachin.mokashi@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-sachin-mokashis-email-address.patch removed from -mm tree
Message-Id: <20250710055943.3E6DBC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update Sachin Mokashi's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-sachin-mokashis-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sachin Mokashi <sachin.mokashi@intel.com>
Subject: mailmap: update Sachin Mokashi's email address
Date: Tue, 24 Jun 2025 10:12:20 -0400

As previous contributions were made with the older email address, which is
no longer in use.  Update my new address to map the old one.

Link: https://lkml.kernel.org/r/20250624141220.1264691-1-sachin.mokashi@intel.com
Signed-off-by: Sachin Mokashi <sachin.mokashi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-sachin-mokashis-email-address
+++ a/.mailmap
@@ -670,6 +670,7 @@ Muchun Song <muchun.song@linux.dev> <smu
 Ross Zwisler <zwisler@kernel.org> <ross.zwisler@linux.intel.com>
 Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
+Sachin Mokashi <sachin.mokashi@intel.com> <sachinx.mokashi@intel.com>
 Sachin P Sant <ssant@in.ibm.com>
 Sai Prakash Ranjan <quic_saipraka@quicinc.com> <saiprakash.ranjan@codeaurora.org>
 Sakari Ailus <sakari.ailus@linux.intel.com> <sakari.ailus@iki.fi>
_

Patches currently in -mm which might be from sachin.mokashi@intel.com are


