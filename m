Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E930C33D506
	for <mm-commits@vger.kernel.org>; Wed,  8 Apr 2026 01:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775612508; cv=none; b=s40Ua3RV/kGuO18K9ETqMwWf4HdfzHPqMuEeC8xA4Y9ldRBiXA4owBx+ohKRWSS5t8ArwFW2WVh4iKM4T2/Ebumm/h4GCDY0RTWWhem4Q3TSFaQdjrZ/pPxE20Tts9gUzddF73X8tmU4b8+kvIyHQmlNSHIa/P1KV4D/NUdM2Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775612508; c=relaxed/simple;
	bh=KgXpP2GWcN+iDatb2AozytSk+1lXOi1O4smYxzSvLq8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=QrAnE3QgNTt8Ku0mW+ptLMd3XN+Ajk7RM71RkPDlVHt6ZnSugUh1lNi++u7k/u6HD/Ep2lJEMRKjkz57xEAofKoAFJ4SM1tlVsCjQq0Q8NfaU13I6o1PZocymAU1dOJi8FKpuUyCPEtJ2IQMqyVz8T5sqKMLj8L22biCZ3i+TkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ko0DRC/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ko0DRC/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2449DC19421;
	Wed,  8 Apr 2026 01:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775612507;
	bh=KgXpP2GWcN+iDatb2AozytSk+1lXOi1O4smYxzSvLq8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ko0DRC/mDnTQy2fYNIn/E87RjGsANvC19+G/333u3vIv48bkYsBNwvR3rv0+BBUTo
	 5OinARhsXk1j3wPH7IWLw1zNOnwGphKjx6t0APlyNl4fpuq99vI0ViR0LE7KcwdGGU
	 Op2cscgg0BBaWKV0S50qjL4D0x+3FpkFYrwfkEiw=
Date: Tue, 7 Apr 2026 18:41:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: mm-commits@vger.kernel.org, surenb@google.com, rppt@kernel.org,
 mhocko@suse.com, ljs@kernel.org, liam.howlett@oracle.com, leon@kernel.org,
 jgg@ziepe.ca, david@kernel.org, balbirs@nvidia.com, apopple@nvidia.com
Subject: Re: +
 lib-test_hmm-evict-device-pages-on-file-close-to-avoid-use-after-free.patch
 added to mm-new branch
Message-Id: <20260407184146.e704e495f5d3555be0682282@linux-foundation.org>
In-Reply-To: <ebde5bba-8147-40fe-a008-7cffad421637@linux.dev>
References: <20260401003334.2A85EC19423@smtp.kernel.org>
	<ebde5bba-8147-40fe-a008-7cffad421637@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 8 Apr 2026 09:08:41 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> > Cc: <stable@vger,kernel.org>
> 
> Cc: <stable@vger.kernel.org>

yup, thanks.
