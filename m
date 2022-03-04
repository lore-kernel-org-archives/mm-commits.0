Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557A2C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 03:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbiCDDDZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiCDDDY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 22:03:24 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9749213DEE
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 19:02:36 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K8t210Z7Pz4xcq;
        Fri,  4 Mar 2022 14:02:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646362954;
        bh=+vizi3YjoyiyA0bWqtUJ4LkFh5jhFWN+aYEmaZaI2Cs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qFnazkUVOkjqrMOIr0Tj99dLmAhkbfvNRedPGdpy6ao8HEWgPo3e31C/ah19L0N/C
         GlVvjQwDmxooGaG6RqYRfIorXtvZG3AtQXDHq+ltxyPJUaZXKxMU1OkIKGvw0wNsqc
         XeP2eoTnfCASnYGzRoNpV86Hro8rsAsNMJIROwVnc5fWkNP8wmQmRHjhbPcGE/dciy
         bwvAcjN0XrKKS9G5TCat4KoiH9WOCCre+38tpRnVIx9SW+bG+A0VYjkLEfFhk/K3F5
         quvMThh/HtrcdDqxAADOED+SwSIJ1I1Blh1/SSUjLYxOEhZEWKgUI7LStkUekFqBBp
         0zrkSX4VtOT4g==
Date:   Fri, 4 Mar 2022 14:02:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com,
        peterx@redhat.com, namit@vmware.com, jack@suse.cz,
        david@redhat.com, aarcange@redhat.com
Subject: Re: +
 userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch added to
 -mm tree
Message-ID: <20220304140231.4e8723d8@canb.auug.org.au>
In-Reply-To: <20220304015358.54ED3C004E1@smtp.kernel.org>
References: <20220304015358.54ED3C004E1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/P4AoiyABmm.KNWtycAnF1VA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/P4AoiyABmm.KNWtycAnF1VA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 03 Mar 2022 17:53:57 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> The patch titled
>      Subject: userfaultfd-provide-unmasked-address-on-page-fault-v3-fix
> has been added to the -mm tree.  Its filename is
>      userfaultfd-provide-unmasked-address-on-page-fault-v3-fix.patch

Added to linux-next today.
--=20
Cheers,
Stephen Rothwell

--Sig_/P4AoiyABmm.KNWtycAnF1VA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIhgUcACgkQAVBC80lX
0GyJTwf/ZSQgJjg0nNJ7sPEq6im7UVBqwdBYVaPJjfbTHcdZsCLTaV1ycagDOkvq
B2IYSuVMXw6TpEZOjfrym2Xwjtqyqpk6eTQ8aK7VSRSySAwOXMNBuulo/cnXpqjo
A1DuuVLFkP0Ux74eJ6cyjjoyJeuNpv/b4fNc8donh0ufMQDpHxFsaRFW066ryo/3
/cNyOJ7ZKrVj3VnTDcL4aqEBC6wDbG5g0A/XAOt8oBKxudUjKnWiRfU4vgTnngLZ
Q1nJzPuQPI+Gq5JGwB6qOFd3R7jRcijNxH00K4yRF28y2l9Mc8d0PwmNfvbhs9Vw
i8cN3J8LeFCaNHE/d/yUt+9KjN70DA==
=uq/9
-----END PGP SIGNATURE-----

--Sig_/P4AoiyABmm.KNWtycAnF1VA--
