Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CF81B3957
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860848; cv=none; b=Bu3N72BhEQioVupCszRBUSMU0BHCptzNETL+rNA4Xf3M6wIzwnHme6UGa2qrsX0KgTsAexK0MsHUstwCEDzDXodZL1MQchYy8SO/gGYkL21BZUC3F8iRgw/E7vK0pSs2HfoFB+8mFa3/UE2ITqMykTT91YU8LvVme15e1gJeI6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860848; c=relaxed/simple;
	bh=TgoQCXZ7IrI1KZN9ThlJIokYFq6Wb9y1K3gzroPRLHE=;
	h=Date:To:From:Subject:Message-Id; b=N57+FcFm4BGAidn4DOqAnTS0JKs1nZ5ZWM0DHghM5vKDx0/cvWjCgenYRn9sixG6lBAV6eZt3J4vaQWnohOEQ3u/A5k59wYzjKyj7t9/4pIjX5D0eOG2kRNwHQnF7KbyLNCEq6lmco3aC82q/z7UMou0TvHnrfamGNJItt90I54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wReHTE4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wReHTE4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E058C4CEE2;
	Tue, 18 Feb 2025 06:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860848;
	bh=TgoQCXZ7IrI1KZN9ThlJIokYFq6Wb9y1K3gzroPRLHE=;
	h=Date:To:From:Subject:From;
	b=wReHTE4ug71lN5mU/pSXcvYMtQYCLN6Wg2+cUtk5qGNG7pwxrLa0ql5Y+RmrAbnMG
	 0FWTNZGQyLMQ4X38UNQ0Ga9TnxSN761Dr+86Hvqu44jSS8JPj1o/9esfXcOqXFUYBX
	 M5jN2H4pOW02Bmvx56M7YXrnV0FpW9HrP6l4Em7M=
Date: Mon, 17 Feb 2025 22:40:47 -0800
To: mm-commits@vger.kernel.org,jeff.johnson@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-jeff-johnson.patch removed from -mm tree
Message-Id: <20250218064048.4E058C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: .mailmap: add entries for Jeff Johnson
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-jeff-johnson.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: .mailmap: add entries for Jeff Johnson
Date: Wed, 05 Feb 2025 12:01:00 -0800

Map past iterations of my e-mail addresses to the current one.

Link: https://lkml.kernel.org/r/20250205-jjohnson-mailmap-v1-1-269cb7b1710d@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-jeff-johnson
+++ a/.mailmap
@@ -317,6 +317,8 @@ Jayachandran C <c.jayachandran@gmail.com
 Jean Tourrilhes <jt@hpl.hp.com>
 Jeevan Shriram <quic_jshriram@quicinc.com> <jshriram@codeaurora.org>
 Jeff Garzik <jgarzik@pretzel.yyz.us>
+Jeff Johnson <jeff.johnson@oss.qualcomm.com> <jjohnson@codeaurora.org>
+Jeff Johnson <jeff.johnson@oss.qualcomm.com> <quic_jjohnson@quicinc.com>
 Jeff Layton <jlayton@kernel.org> <jlayton@poochiereds.net>
 Jeff Layton <jlayton@kernel.org> <jlayton@primarydata.com>
 Jeff Layton <jlayton@kernel.org> <jlayton@redhat.com>
_

Patches currently in -mm which might be from jeff.johnson@oss.qualcomm.com are


